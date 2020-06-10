//
//  iCloudDelegate.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 04.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CloudCore

class iCloudDelegate : CloudCoreDelegate {
    
    func willSyncFromCloud() {
        log.verbose("🔁 Started fetching from iCloud")
    }
    
    func didSyncFromCloud() {
        log.verbose("✅ Finishing fetching from iCloud")
    }
    
    func willSyncToCloud() {
        log.verbose("💾 Started saving to iCloud")
    }

    func didSyncToCloud() {
        log.verbose("✅ Finished saving to iCloud")
    }
    
    func error(error: Error, module: Module?) {
        log.error("⚠️ CloudCore error detected in module \(String(describing: module)): \(error)")
    }
    
}
