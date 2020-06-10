//
//  LocationService.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 01.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox
import UIKit

class LocationService : NSObject {
    
    static let `default` = LocationService()
    
    private var locationManager: CLLocationManager!
    private var currentUserLocation: CLLocationCoordinate2D!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func currentLocation() -> CLLocationCoordinate2D {
        return currentUserLocation
    }
    
    public func startLocationRequest() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func checkPermissionForLocation(view: UIViewController) {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController.init(title: "Permission denied", message: "We need your permission to take your colors", preferredStyle: .alert)
                
                // Open Settings to allow locationrequests
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }
                alert.addAction(settingsAction)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: {
                        
                    })
                }))
                view.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - LocationManagerDelegate
extension LocationService : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startLocationRequest()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        currentUserLocation = location
        manager.stopUpdatingLocation()
    }
    
    
}
