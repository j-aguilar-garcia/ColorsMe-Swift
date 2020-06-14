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
                    //log.debug("saved Backendless Annotation: \(savedAnnotation.debugDescription)")
                    
                    let realmAnnotation = RealmAnnotation(annotation: savedAnnotation, isMyColor: byUser)
                    //log.debug("saved: realmAnnotation: objectid = \(realmAnnotation.objectId!) & guid = \(realmAnnotation.guid!)")
                    DispatchQueue.main.async {
                        DataManager.shared.localDataManager.saveLocal(annotation: realmAnnotation)
                    }
                    let cmAnnotation = CMAnnotation(annotation: savedAnnotation, isMyColor: byUser)
                    
                    DataManager.shared.cloudDataManager.addAnnotation(annotation: cmAnnotation)
                    
                })
            }
            
        })
    }
    
    
    open func deleteAnnotation(_ annotation: CMAnnotation, completion: @escaping () -> ()) {
        DataManager.shared.dataManager(id: annotation.objectId!, willDeltewith: .both)
        DataManager.shared.cloudDataManager.deleteAnnotationBy(objectId: annotation.objectId!)
        completion()
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
