//
//  AppConfiguration.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 26.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

class AppConfiguration {
    
    static let `default` = AppConfiguration()
    
    var backendlessServerUrl: String!
    var backendlessApiKey: String!
    var backendlessAppKey: String!
    
    var swiftyBeaverAppId: String!
    var swiftyBeaverAppSecret: String!
    var swiftyBeaverEncryptionKey: String!
    
    
    init() {
        let bundleURL = Bundle.main.url(forResource: "AppProperties", withExtension: "plist")!
        let plist = NSDictionary(contentsOf: bundleURL)!
        
        backendlessServerUrl = plist["backendless_server_url"] as? String
        backendlessApiKey = plist["backendless_api_key"] as? String
        backendlessAppKey = plist["backendless_application_key"] as? String
        
        swiftyBeaverAppId = plist["swiftybeaver_app_id"] as? String
        swiftyBeaverAppSecret = plist["swiftybeaver_app_secret"] as? String
        swiftyBeaverEncryptionKey = plist["swiftybeaver_encryption_key"] as? String
    }
    
}
