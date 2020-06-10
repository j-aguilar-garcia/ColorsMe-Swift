//
//  iCloudDelegate.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 10.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CloudCore

class iCloudDelegate : CloudCoreDelegate {
    
    func didSyncFromCloud() {
        NotificationCenter.default.post(name: .didSyncFromCloud, object: nil)
    }
    
}
