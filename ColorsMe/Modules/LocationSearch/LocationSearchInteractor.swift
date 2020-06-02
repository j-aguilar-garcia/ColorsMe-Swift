//
//  LocationSearchInteractor.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 01.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import MapboxGeocoder
import Mapbox
import Turf

final class LocationSearchInteractor {
    var presenter: LocationSearchPresenterInterface!
    
    let geocoder = Geocoder.shared
}

// MARK: - Extensions -

extension LocationSearchInteractor: LocationSearchInteractorInterface {
    
    func search(text: String) {
        let options = ForwardGeocodeOptions(query: text)
        
        options.focalLocation = CLLocation(
            latitude: LocationService.default.currentLocation().latitude,
            longitude: LocationService.default.currentLocation().longitude)
        
        options.maximumResultCount = 10
        options.allowedScopes = [.locality, .country, .place, .region]
        
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard error == nil else {
                log.error(error?.localizedDescription as Any)
                log.error(error?.localizedFailureReason as Any)
                return
            }
            guard let _ = placemarks?.first else {
                return
            }
            self.presenter.showResults(placemarks!)
        }
    }
    
    
    func parseGeoJSON(placemark: GeocodedPlacemark) {
        var results = [CLLocationCoordinate2D]()
        let search = placemark.qualifiedName!
        let fullUrl = "https://nominatim.openstreetmap.org/search?q=" + search + "&polygon_geojson=1&format=geocodejson&limit=2"
        let encodedUrl = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        let url = NSURL(string: encodedUrl)!
        print("url \(url)")
        URLSession.shared.dataTask(with: url as URL) { data, response, error  in
            guard let data = data else { return }
            do {
                
                DispatchQueue.main.async {
                    let geoJson = try! GeoJSON.parse(FeatureCollection.self, from: data)
                    let feature = geoJson.features.last!
                    
                    switch feature {
                        
                    case .multiPolygonFeature(let multipolygon):
                        let coordinates = multipolygon.geometry.coordinates.first!.first!
                        log.debug("multipolygon: \(coordinates.count)")
                        results.append(contentsOf: coordinates)
                        break
                        
                    case .polygonFeature(let polygon):
                        let coordinates = polygon.geometry.coordinates.first!
                        log.debug("polygon: \(coordinates.count)")
                        results.append(contentsOf: coordinates)
                        break
                        
                    default:
                        break
                    }
                    
                    if !results.isEmpty {
                        self.presenter.onGeoJsonRetrieved(coordinates: results, placemark: placemark)
                    }
                }
            }
        }.resume()
        
    }
    
}
