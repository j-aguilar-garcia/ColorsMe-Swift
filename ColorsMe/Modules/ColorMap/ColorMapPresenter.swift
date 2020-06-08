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
    
    var filteredAnnotations: [CMAnnotation]?
    
}

// MARK: - Extensions -

extension ColorMapPresenter: ColorMapPresenterInterface {
    
    func willAddAnnotation(_ annotation: CMAnnotation) {
        view.addAnnotation(annotation)
    }
    
    func willRemoveAnnotation(_ annotation: CMAnnotation) {
        view.removeAnnotation(annotation)
    }
    
    
    func viewDidLoad() {
        guard let annotation = annotation else {
            return
        }
        view.zoomToAnnotation(annotation: annotation)
    }
    
    func viewWillAppear(animated: Bool) {
    }
    
    func filteredAnnotationsDidChange(_ annotations: [CMAnnotation]) {
        filteredAnnotations = annotations
        view.showAnnotations(annotations, animated: true)
    }
    
    func didSelectMenuButton(at index: Int, mapView: MGLMapView) {
        guard let mapLayer = ColorMapLayerType(rawValue: index) else { return }
        if mapView.annotations != nil {
            filteredAnnotations = mapView.annotations as? [CMAnnotation]
        }
        view.showMapLayer(layerType: mapLayer, annotations: filteredAnnotations)
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
    
    func reachabilityChanged(_ isReachable: Bool) {
        view.reachabilityChanged(isReachable)
    }
    
    func checkForUserAnnotation(annotation: CMAnnotation) -> Bool {
        return interactor.checkForAnnotationInCoreData(annotation: annotation)
    }
}
