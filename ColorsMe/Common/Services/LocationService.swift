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
        startLocationRequest()
    }
    
    func currentLocation() -> CLLocationCoordinate2D? {
        if CLLocationManager.locationServicesEnabled() {
            return currentUserLocation
        } else {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            checkPermissionForLocation(view: delegate.inputViewController!)
            return nil
        }
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
                let alert = UIAlertController.init(title: "Permission denied", message: "You have not allowed us to retrieve your location. We need your permission to take your colors", preferredStyle: .alert)
                
                // Open Settings to allow locationrequests
                let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            log.verbose("Settings opened: \(success)")
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
    
    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
}

// MARK: - LocationManagerDelegate
extension LocationService : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            self.startLocationRequest()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        currentUserLocation = location
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            
            log.error("LocationManager failed with code: \(error.code), \(error.localizedDescription)")
            if error.code == .denied {
                #warning("Pop up for settings")
                manager.stopUpdatingLocation()
                
                self.checkPermissionForLocation(view: delegate.inputViewController!)
            } else if error.code == .network || error.code == .locationUnknown {
                let alert = UIAlertController.init(title: "Where are you?", message: "Something's gone wrong. We do not know where you are, please make sure you have an internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: {
                        
                    })
                }))
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }

        }
    }
    
}
