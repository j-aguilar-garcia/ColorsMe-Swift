//
//  LocationSearchWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 01.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import Mapbox

final class LocationSearchWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "LocationSearch", bundle: nil)
    var delegate: LocationSearchDelegate?

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: LocationSearchViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = LocationSearchInteractor()
        let presenter = LocationSearchPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }

}

// MARK: - Extensions -

extension LocationSearchWireframe: LocationSearchWireframeInterface {
    
    func navigate(option: LocationSearchNavigationOption) {
        switch option {
            
        case .removeOverlay:
            delegate?.willRemoveOverlay()
            break
            
        case .showSearchResults(let coordinates, let placemark):
            delegate?.didRetrieveCoordinates(coordinates: coordinates, placemark: placemark)
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            break
            
        }
        log.debug("")

    }
    
    
    
}
