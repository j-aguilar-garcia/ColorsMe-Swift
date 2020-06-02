//
//  ColorMapPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox

final class ColorMapPresenter {

    // MARK: - Private properties -

    private unowned let view: ColorMapViewInterface
    private let interactor: ColorMapInteractorInterface
    private let wireframe: ColorMapWireframeInterface
    private var annotation: CMAnnotation? = nil
    

    // MARK: - Lifecycle -

    init(view: ColorMapViewInterface, interactor: ColorMapInteractorInterface, wireframe: ColorMapWireframeInterface, annotation: CMAnnotation? = nil) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.annotation = annotation
    }
}

// MARK: - Extensions -

extension ColorMapPresenter: ColorMapPresenterInterface {
    
    func viewDidLoad() {
        guard let annotation = annotation else {
            return
        }
        view.zoomToAnnotation(annotation: annotation)
    }
    
    func didSelectMenuButton(at index: Int) {
        guard let mapLayer = ColorMapLayerType(rawValue: index) else { return }
        view.showMapLayer(layerType: mapLayer, annotations: nil)
    }
    
    func didSelectFilterButton() {
        wireframe.navigate(to: .pickerdialog)
    }
    
    func willUpdateScale(value: Float, duration: Double) {
        view.updateScale(value: value, duration: duration)
    }
    
    func shouldUpdateScale(_ mapView: MGLMapView, _ oldValue: Float) {
        interactor.shouldUpdateScale(mapView: mapView, oldValue: oldValue)
    }
}
