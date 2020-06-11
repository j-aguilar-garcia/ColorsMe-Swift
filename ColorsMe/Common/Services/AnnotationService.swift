//
//  AnnotationService.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CoreData
import CloudCore
import Mapbox
import MapboxGeocoder

class AnnotationService {
    
    static let `default` = AnnotationService()
    
    let delegate: AppDelegate
    
    init() {
        delegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    open func addAnnotation(color: EmotionalColor, byUser: Bool = false, completion: @escaping (CMAnnotation) -> ()) {
        createAnnotation(with: color, completion: { annotation in
            let cmAnnotation = CMAnnotation(annotation: annotation, isMyColor: byUser)
            completion(cmAnnotation)
            
            DispatchQueue.global(qos: .background).async {
                DataManager.shared.remoteDataManager.saveToBackendless(annotation: annotation, completion: { savedAnnotation in
                    log.debug("saved Backendless Annotation: \(savedAnnotation.debugDescription)")

                    DispatchQueue.main.async {

                        let realmAnnotation = RealmAnnotation(annotation: savedAnnotation, isMyColor: byUser)
                        log.debug("saved: realmAnnotation: objectid = \(realmAnnotation.objectId!) & guid = \(realmAnnotation.guid!)")

                        let cmAnnotation = CMAnnotation(annotation: savedAnnotation, isMyColor: byUser)

                        DataManager.shared.cloudDataManager.addAnnotation(annotation: cmAnnotation)
                        DataManager.shared.localDataManager.saveLocal(annotation: realmAnnotation)
                    }
                })
            }
            
        })
    }
    
    open func deleteAnnotation(id: String, objectId: NSManagedObjectID) {
        DataManager.shared.dataManager(id: id, willDeltewith: .both)
        delegate.persistentContainer.performBackgroundTask { (context) in
            context.name = CloudCore.config.pushContextName
            if let objectToDelete = try? context.existingObject(with: objectId) {
                log.debug("delete iCloud Annotation: \(objectToDelete)")
                context.delete(objectToDelete)
                try? context.save()
            }
        }
    }
    

    
    private func createAnnotation(with color: EmotionalColor, completion: @escaping (Annotation) -> ()) {
        let annotation = Annotation()
        
        let currentUserLocation = LocationService.default.currentLocation()
        
        let formatter = DateFormatter.yyyyMMddHHmmss
        let titleDate = formatter.string(from: Date())
        annotation.title = titleDate
        
        annotation.color = color.rawValue

        annotation.longitude = NSNumber(value: currentUserLocation.longitude)
        annotation.latitude = NSNumber(value: currentUserLocation.latitude)
        annotation.guid = UUID().uuidString
        reverseGeocoding(latitude: currentUserLocation.latitude, longitude: currentUserLocation.longitude, completion: { placemark in
            annotation.country = placemark.postalAddress?.country
            annotation.city = placemark.postalAddress?.city
            annotation.isocountrycode = placemark.postalAddress?.isoCountryCode
            annotation.street = placemark.postalAddress?.street
            completion(annotation)
        })
    }
    
    
    private func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (GeocodedPlacemark) -> ()) {
        let geocoder = Geocoder.shared
        let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))

            _ = geocoder.geocode(options) { (placemarks, attribution, error) in
                guard let placemark = placemarks?.first else {
                    return
                }
                completion(placemark)
            }
    }
    
    
    
    
}
