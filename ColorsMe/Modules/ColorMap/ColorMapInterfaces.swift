//
//  ColorMapInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import Mapbox

enum ColorMapNavigationOption {
    case pickerdialog
}

enum ColorMapViewLayer {
    case heatmap
    case clustermap
}

protocol ColorMapWireframeInterface: WireframeInterface {
    func navigate(to option: ColorMapNavigationOption)
}

protocol ColorMapViewInterface: ViewInterface {    
    func updateScale(value: Float, duration: Double)
    func showScale(_ animated: Bool)
    func hideScale(_ animated: Bool)
    func switchAppearanceFor(mapView: MGLMapView)
    func addMenuButton()
    func zoomToAnnotation(annotation: CMAnnotation)
    
    func showMapLayer(layerType: ColorMapLayerType, annotations: [CMAnnotation]?)
}

protocol ColorMapPresenterInterface: PresenterInterface {
    func didSelectFilterButton()
    func didSelectMenuButton(at index: Int)
    func shouldUpdateScale(_ mapView: MGLMapView, _ oldValue: Float)
    func willUpdateScale(value: Float, duration: Double)
}

protocol ColorMapInteractorInterface: InteractorInterface {
    func shouldUpdateScale(mapView: MGLMapView, oldValue: Float)
}

// MARK: - Menubutton

enum ColorMapLayerType : Int {
    case defaultmap = 0
    case heatmap = 1
    case clustermap = 2
}


// MARK: - PickerDialog

protocol PickerDialogDelegate {
    func pickerDialogDidChange(with option: PickerDialogFilterOption, annotations: [CMAnnotation])
    func pickerDialogDidClose()
}
