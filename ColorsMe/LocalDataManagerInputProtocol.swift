//
//  LocalDataManagerInputProtocol.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

protocol LocalDataManagerInputProtocol {
            
    func saveLocal(annotation: RealmAnnotation)
    
    func updateLocal(annotation: RealmAnnotation)
    
    func deleteLocal(annotation: RealmAnnotation)
    
    func getAllLocal() -> [CMAnnotation] 
 
}
