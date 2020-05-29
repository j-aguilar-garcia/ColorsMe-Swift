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

class LocalDataManager : LocalDataManagerInputProtocol {
    
    let realm = try! Realm()
    
    func saveLocal(annotation: RealmAnnotation) {
        try! realm.write {
            log.debug("Realm add")
            realm.add(annotation, update: .all)
        }
    }
    
    func updateLocal(annotation: RealmAnnotation) {
        try! realm.write {
            log.debug("Realm Update")
            realm.add(annotation, update: .all)
        }
    }
    
    func deleteLocal(annotation: RealmAnnotation) {
        try! realm.write {
            realm.delete(annotation)
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
    
    
    func getAllCoordinates() -> [CLLocationCoordinate2D] {
        let annotations = getAllLocal()
        var coordinates = [CLLocationCoordinate2D]()
        annotations.forEach({ coordinates.append(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)) })
        return coordinates
    }
    
    
    func filterLocal(by option: PickerDialogFilterOption) -> [CMAnnotation] {
        switch option {
            
        case .allcolors:
            return getAllLocal()
            
        case .mycolors:
            return getAllLocal()
            // TODO: - filter my colors
            //let predicate = NSPredicate(format: "isMyColor == %@", true)
            //return filterLocal(with: predicate)
            
        case .today:
            let today = Date()
            let interval = Calendar.current.dateInterval(of: .day, for: today)
            let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", interval!.start as NSDate, interval!.end as NSDate)
            return filterLocal(with: predicate)
            
        case .yesterday:
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            let interval = Calendar.current.dateInterval(of: .day, for: yesterday!)
            let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", interval!.start as NSDate, interval!.end as NSDate)
            return filterLocal(with: predicate)
            
        case .lastweek:
            let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            let interval = Calendar.current.dateInterval(of: .day, for: lastWeek!)
            let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", interval!.start as NSDate, interval!.end as NSDate)
            return filterLocal(with: predicate)
            
        case .year(let date):
            let interval = Calendar.current.dateInterval(of: .year, for: date)
            let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", interval!.start as NSDate, interval!.end as NSDate)
            return filterLocal(with: predicate)
            
        case .month(let date):
            let interval = Calendar.current.dateInterval(of: .month, for: date)
            let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", interval!.start as NSDate, interval!.end as NSDate)
            return filterLocal(with: predicate)
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
    
}