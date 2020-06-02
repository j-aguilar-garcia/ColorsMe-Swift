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
    
    let delegate: AppDelegate
    
    init() {
        delegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    open func addAnnotation(color: EmotionalColor, completion: @escaping (CMAnnotation) -> ()) {
       
        createAnnotation(with: color, completion: { annotation in
            DataManager.shared.remoteDataManager.saveToBackendless(annotation: annotation, completion: { annotation in
                log.debug("saved Backendless Annotation: \(annotation.debugDescription)")
                let realmAnnotation = RealmAnnotation(annotation: annotation)
                
                DataManager.shared.localDataManager.saveLocal(annotation: realmAnnotation)
                let cmAnnotation = CMAnnotation(annotation: annotation)
                
                self.saveAnnotationToiCloud(annotation: cmAnnotation)
                
                completion(cmAnnotation)
            })
        })
    }
    
    private func saveAnnotationToiCloud(annotation: CMAnnotation) {
        let userAnnotation = UserAnnotation(context: self.delegate.persistentContainer.viewContext)
        userAnnotation.beObjectId = annotation.objectId
        userAnnotation.city = annotation.city
        userAnnotation.color = annotation.color.rawValue
        userAnnotation.isMyColor = true
        userAnnotation.country = annotation.country
        userAnnotation.countryIsoCode = annotation.isocountrycode
        userAnnotation.created = annotation.created
        userAnnotation.guid = annotation.guid
        userAnnotation.latitude = annotation.latitude
        userAnnotation.longitude = annotation.longitude
        userAnnotation.title = annotation.title
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