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
import Reachability

class AnnotationService {
    
    static let `default` = AnnotationService()
    
    let delegate: AppDelegate
    
    init() {
        delegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    open func addAnnotation(color: EmotionalColor, byUser: Bool = false, completion: @escaping (CMAnnotation) -> ()) {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            let alert = UIAlertController.init(title: "You don't have an internet connection.", message: "We do not know where you are, please make sure you have an internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                alert.dismiss(animated: true, completion: {
                    
                })
            }))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        
        createAnnotation(with: color, completion: { annotation in
            let cmAnnotation = CMAnnotation(annotation: annotation, isMyColor: byUser)
            completion(cmAnnotation)
            
            DispatchQueue.global(qos: .background).async {
                DataManager.shared.remoteDataManager.saveToBackendless(annotation: annotation, completion: { savedAnnotation in

                    DispatchQueue.main.async {
                        let realmAnnotation = RealmAnnotation(annotation: savedAnnotation, isMyColor: byUser)
                        DataManager.shared.localDataManager.saveLocal(annotation: realmAnnotation)
                        let cmAnnotation = CMAnnotation(annotation: savedAnnotation, isMyColor: byUser)
                        
                        DataManager.shared.cloudDataManager.addAnnotation(annotation: cmAnnotation)
                    }
                    
                })
            }
            
        })
    }
    
    private func saveAnnotationOffline(annotation: Annotation, byUser: Bool) {
        annotation.objectId = annotation.guid
        DispatchQueue.main.async {
            let realmAnnotation = RealmAnnotation(annotation: annotation, isMyColor: byUser)
            DataManager.shared.localDataManager.saveLocal(annotation: realmAnnotation)
            let cmAnnotation = CMAnnotation(annotation: annotation, isMyColor: byUser)
            
            DataManager.shared.cloudDataManager.addAnnotation(annotation: cmAnnotation)
        }
    }
    
    /// Updates the annotations that were created offline once the Internet connection is established
    open func updateOfflineCreatedAnnotations(annotation: Annotation) {
        
    }
    
    
    open func deleteAnnotation(_ annotation: CMAnnotation, completion: @escaping () -> ()) {
        DataManager.shared.dataManager(id: annotation.objectId!, willDeltewith: .both)
        DataManager.shared.cloudDataManager.deleteAnnotationBy(objectId: annotation.objectId!)
        completion()
    }
    
    private func createAnnotation(with color: EmotionalColor, completion: @escaping (Annotation) -> ()) {
        let annotation = Annotation()
        
        guard let currentUserLocation = LocationService.default.currentLocation() else {
            LocationService.default.checkPermissionForLocation(view: (UIApplication.shared.windows.first?.rootViewController)!)
            return
        }
        
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
