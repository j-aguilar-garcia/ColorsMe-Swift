//
//  LocalDataManagerInputProtocol.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox

protocol LocalDataManagerProtocol {
            
    func saveLocal(annotation: RealmAnnotation)
    
    func updateLocal(annotation: RealmAnnotation)
    
    func deleteLocal(annotation: RealmAnnotation)
    
    func deleteLocal(by id: String)
    
    func getAllLocal() -> [CMAnnotation] 
 
    func filterLocal(by option: PickerDialogFilterOption) -> [CMAnnotation]
    
    func filterLocal(with predicate: NSPredicate) -> [CMAnnotation]
    
    func getAnnotationBy(primaryKey: String) -> CMAnnotation?
    
    func getObjectBy(primaryKey: String) -> RealmAnnotation?
}
