//
//  LocationSearchPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 01.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import MapboxGeocoder

final class LocationSearchPresenter {

    // MARK: - Private properties -

    private unowned let view: LocationSearchViewInterface
    private let interactor: LocationSearchInteractorInterface
    private let wireframe: LocationSearchWireframeInterface
    
    public var searchResults = [GeocodedPlacemark]()
    
    // MARK: - Lifecycle -

    init(view: LocationSearchViewInterface, interactor: LocationSearchInteractorInterface, wireframe: LocationSearchWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension LocationSearchPresenter: LocationSearchPresenterInterface {    
    
    func clearSearch() {
        wireframe.navigate(option: .removeOverlay)
    }
    
    func showResults(_ results: [GeocodedPlacemark]) {
        searchResults = results
        view.reloadData()
    }
    
    func search(text: String) {
        interactor.search(text: text)
    }
    
    func didSelectRowAt(index: Int) {
        wireframe.navigate(option: .removeOverlay)
        interactor.parseGeoJSON(placemark: searchResults[index])
    }
    
    func onGeoJsonRetrieved(coordinates: [CLLocationCoordinate2D], placemark: GeocodedPlacemark) {
        log.debug("")
        wireframe.navigate(option: .showSearchResults(coordinates, placemark))
    }
    
}
