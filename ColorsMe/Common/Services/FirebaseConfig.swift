//
//  FirebaseConfig.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseConfig {

    static let shared = FirebaseConfig()

    var remoteConfig: RemoteConfig!
    
    init() {
        setUpRemoteConfig()
        fetchConfig()
    }
    
    func setUpRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 5
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    

    func fetchConfig() {
        remoteConfig.fetch(withExpirationDuration: TimeInterval(3600)) { (status, error) -> Void in
            guard error == nil else {
                print("remoteConfig fetchConfig error =  \(String(describing: error?.localizedDescription))")
                return }
            switch status {
            case .success:
                print("remoteConfig fetchConfig success")
                self.remoteConfig.activate { (error) in
                    print("remoteConfig activate success \(String(describing: error?.localizedDescription))")
                }
                break
            default:
                print("\(#function) RemoteConfig not fetched")
                break
            }
        }
    }
    
}
