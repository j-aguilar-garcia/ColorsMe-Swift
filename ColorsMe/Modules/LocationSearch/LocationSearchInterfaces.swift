//
//  LocationSearchInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 01.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import MapboxGeocoder
import Mapbox

enum LocationSearchNavigationOption {
    case removeOverlay
    case showSearchResults([CLLocationCoordinate2D], GeocodedPlacemark)
}

protocol LocationSearchDelegate {
    func didRetrieveCoordinates(coordinates: [CLLocationCoordinate2D], placemark: GeocodedPlacemark)
    func willRemoveOverlay()
}

protocol LocationSearchWireframeInterface: WireframeInterface {
    func navigate(option: LocationSearchNavigationOption)
}

protocol LocationSearchViewInterface: ViewInterface {
    func reloadData()
}

protocol LocationSearchPresenterInterface: PresenterInterface {
    var searchResults: [GeocodedPlacemark] { get }
    func clearSearch()
    func search(text: String)
    func showResults(_ results: [GeocodedPlacemark])
    func didSelectRowAt(index: Int)
    func onGeoJsonRetrieved(coordinates: [CLLocationCoordinate2D], placemark: GeocodedPlacemark)
}

protocol LocationSearchInteractorInterface: InteractorInterface {
    func search(text: String)
    func parseGeoJSON(placemark: GeocodedPlacemark)
}
