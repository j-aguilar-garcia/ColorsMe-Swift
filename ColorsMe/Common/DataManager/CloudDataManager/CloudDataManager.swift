//
//  CloudDataManager.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 09.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class CloudDataManager : CloudDataManagerProtocol {
    
    func getAllCloudData(context: NSManagedObjectContext) -> [UserAnnotation]? {
        let fetchRequest : NSFetchRequest<UserAnnotation> = UserAnnotation.fetchRequest()
        let annotations = try? context.fetch(fetchRequest)
        return annotations
    }
    
}
