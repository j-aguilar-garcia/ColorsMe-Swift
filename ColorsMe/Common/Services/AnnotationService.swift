//
//  AnnotationService.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
import Mapbox
import MapboxGeocoder

class AnnotationService {
    
    static let `default` = AnnotationService()
    
    init() {
        
    }
    
    open func addAnnotation(color: EmotionalColor, completion: @escaping (CMAnnotation) -> ()) {
       
        createAnnotation(with: color, completion: { annotation in
            DataManager.shared.remoteDataManager.saveToBackendless(annotation: annotation, completion: { annotation in
                
                let realmAnnotation = RealmAnnotation(annotation: annotation)
                
                DataManager.shared.localDataManager.saveLocal(annotation: realmAnnotation)
                let cmAnnotation = CMAnnotation(annotation: annotation)
                
                completion(cmAnnotation)
            })
        })
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
            annotation.country = placemark.country?.name
            annotation.city = placemark.place?.name
            annotation.isocountrycode = placemark.country?.code
            annotation.street = placemark.address
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
