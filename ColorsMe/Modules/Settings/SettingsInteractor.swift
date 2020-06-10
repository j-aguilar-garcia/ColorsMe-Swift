//
//  SettingsInteractor.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 08.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CloudCore

class SettingsInteractor : SettingsInteractorInterface {
    
    func getUserAnnotationsCount() -> Int {
        return DataManager.shared.dataManager(filterBy: .mycolors, with: .local, completion: {}).count
    }
    
    func enableCloudCore() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let container = delegate.persistentContainer
        CloudCore.enable(persistentContainer: container)
        CloudCore.pull(to: container, error: { (error) in
            log.error(error)
        }) {
            AppData.lastCloudSync = Date()
            log.verbose("some completion")
        }
    }
    
    func disableCloudCore() {
        CloudCore.disable()
    }
    
}
