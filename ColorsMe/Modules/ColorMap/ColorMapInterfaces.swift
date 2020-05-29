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
    func updateScale()
    func showScale(_ animated: Bool)
    func hideScale(_ animated: Bool)
    func switchAppearanceFor(mapView: MGLMapView)
    func addMenuButton()
    
    func removeMapLayers()
    func createHeatMapLayer()
    func createClusterMapLayer()
}

protocol ColorMapPresenterInterface: PresenterInterface {
    func didSelectFilterButton()
    func didSelectMenuButton(at index: Int)
}

protocol ColorMapInteractorInterface: InteractorInterface {
    
}

protocol PickerDialogDelegate {
    func pickerDialogDidChange(with option: PickerDialogFilterOption, annotations: [CMAnnotation])
    func pickerDialogDidClose()
}
