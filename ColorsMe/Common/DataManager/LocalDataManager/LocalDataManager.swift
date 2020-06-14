//
//  LocalDataManager.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 25.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Unrealm
import Mapbox
import CoreData

class LocalDataManager : LocalDataManagerProtocol {
    
    let realm = try! Realm()
    
    func saveLocal(annotation: RealmAnnotation) {
        try! realm.write {
            log.debug("Realm add \(annotation.objectId!)")
            realm.add(annotation, update: .all)
            NotificationCenter.default.post(name: .didAddRealmAnnotation, object: nil)
        }
    }
    
    func updateLocal(annotation: RealmAnnotation) {
        try! realm.write {
            log.debug("Realm Update \(annotation.objectId!)")
            realm.add(annotation, update: .modified)
        }
    }
    
    func deleteLocal(annotation: RealmAnnotation) {
        try! realm.write {
            realm.delete(annotation)
        }
    }
    
    func deleteLocal(by id: String) {
        try! realm.write {
            let objectToDelete = realm.object(ofType: RealmAnnotation.self, forPrimaryKey: id)
            guard let object = objectToDelete else {
                log.error("Can not deleteLocal by Id \(objectToDelete?.objectId!)")
                return
            }
            realm.delete(object)
        }
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
    
    func getAllRealm() -> [RealmAnnotation] {
        let annotationType = RealmAnnotation.self
        let rlmResult = realm.objects(annotationType)
        
        return rlmResult.reversed()
    }
    
    
    func getAllCoordinates() -> [CLLocationCoordinate2D] {
        let annotations = getAllLocal()
        var coordinates = [CLLocationCoordinate2D]()
        annotations.forEach({ coordinates.append(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)) })
        return coordinates
    }
    
    
    func filterLocal(by option: PickerDialogFilterOption) -> [CMAnnotation] {
        realm.refresh()
        switch option {
            
        case .allcolors:
            return getAllLocal()
            
        case .mycolors:
            #warning("Filter my colors!")
            /*
            var annos = [CMAnnotation]()
            
            let cloudAnnotations = DataManager.shared.cloudDataManager.getUserAnnotations()
            let localAnnotations = getAllLocal()
            let annotations = getAllLocal().filter({ $0.isMyColor == true })
            //let fetchRequest : NSFetchRequest<UserAnnotation> = UserAnnotation.fetchRequest()

            //let annotations = try? context.fetch(fetchRequest)
            for anno in cloudAnnotations! {
                if localAnnotations.contains(where: { $0.objectId == anno.beObjectId }) {
                    log.verbose("$0.objectId == anno.beObjectId === true")
                    let local = localAnnotations.first(where: { $0.objectId == anno.beObjectId })
                    annos.append(local!)
                }
            }
            log.verbose("annos = \(annos.count)")
             */
            //let annotations = filterLocal(with: NSPredicate(format: "isMyColor == true"))
            //log.verbose("annotations predicate = \(annotations.count)")
        
            let annotations = DataManager.shared.cloudDataManager.getAnnotations()
            //log.debug(userAnnotations.count)
            return annotations
            
            
            //log.debug(annotations.count)
            //return annotations
            
        case .today:
            let calendar = Calendar.current
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let filteredColorAnnotations = getAllLocal().filter { calendar.date(($0.created), matchesComponents: dateComponents) }
            return filteredColorAnnotations
            
        case .yesterday:
            
            let calendar = Calendar.current
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: yesterday!)
            let filteredColorAnnotations = getAllLocal().filter { calendar.date(($0.created), matchesComponents: dateComponents) }
            return filteredColorAnnotations

        case .lastweek:
            let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            let filteredColorAnnotations = getAllLocal().filter { $0.created > lastWeek! }
            return filteredColorAnnotations
            
        case .year(let date):
            let calendar = Calendar.current
            var dateComponents = DateComponents.init()
            dateComponents.year = calendar.component(.year, from: date)
            
            let filteredColorAnnotations = getAllLocal().filter { calendar.date(($0.created), matchesComponents: dateComponents) }
            return filteredColorAnnotations
            
        case .month(let date):
            let calendar = Calendar.current
            var dateComponents = DateComponents.init()
            dateComponents.year = calendar.component(.year, from: date)
            dateComponents.month = calendar.component(.month, from: date)
            
            let filteredColorAnnotations = getAllLocal().filter { calendar.date(($0.created), matchesComponents: dateComponents) }
            return filteredColorAnnotations
        }
    }
    
    
    func filterLocal(with predicate: NSPredicate) -> [CMAnnotation] {
        let annotationType = RealmAnnotation.self
        let rlmResult = realm.objects(annotationType).filter(predicate)
        var annotations = [CMAnnotation]()
        
        for result in rlmResult {
            let cmAnnotation = CMAnnotation(annotation: result)
            annotations.append(cmAnnotation)
        }
        
        return annotations
    }
    
    
    func getAnnotationBy(primaryKey: String) -> CMAnnotation? {
        let annotationType = RealmAnnotation.self
        guard let rlmResult = realm.object(ofType: annotationType, forPrimaryKey: primaryKey) else {
            return nil
        }
        
        return CMAnnotation(annotation: rlmResult)
    }
    
    
    func getObjectBy(primaryKey: String) -> RealmAnnotation? {
        let annotationType = RealmAnnotation.self
        guard let rlmResult = realm.object(ofType: annotationType, forPrimaryKey: primaryKey) else {
            return nil
        }
        return rlmResult
    }
    
}
