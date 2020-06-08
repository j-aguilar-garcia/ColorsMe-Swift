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
        let fetchRequest : NSFetchRequest<UserAnnotation> = UserAnnotation.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let annotations = try? context.fetch(fetchRequest)
        return annotations?.count ?? 0
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
