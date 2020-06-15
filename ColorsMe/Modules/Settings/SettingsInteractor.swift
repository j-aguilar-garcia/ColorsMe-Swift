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
        return DataManager.shared.localDataManager.filterLocal(by: .mycolors).count
        //return DataManager.shared.cloudDataManager.getAnnotations().count
    }
    
}
