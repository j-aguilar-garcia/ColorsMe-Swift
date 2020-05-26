//
//  LocalDataManager.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 25.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Unrealm

class LocalDataManager : LocalDataManagerInputProtocol {
    
    let realm = try! Realm()
            
    func saveLocal(annotation: RealmAnnotation) {
        try! realm.write {
            log.debug("Realm add")
            realm.add(annotation, update: .all)
        }
    }
    
    func updateLocal(annotation: RealmAnnotation) {
        
    }
    
    func deleteLocal(annotation: RealmAnnotation) {
        
    }
    
    func getAllLocal() -> [CMAnnotation] {
        let annotationType = RealmAnnotation.self
        let rlmResult = realm.objects(annotationType)
    
        var annotations = [CMAnnotation]()
        
        for result in rlmResult {
            let cmAnnotation = CMAnnotation(annotation: result)
            annotations.append(cmAnnotation)
        }
        
        return annotations
    }
    
}
