//
//  ColorMapPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

final class ColorMapPresenter {

    // MARK: - Private properties -

    private unowned let view: ColorMapViewInterface
    private let interactor: ColorMapInteractorInterface
    private let wireframe: ColorMapWireframeInterface

    // MARK: - Lifecycle -

    init(view: ColorMapViewInterface, interactor: ColorMapInteractorInterface, wireframe: ColorMapWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension ColorMapPresenter: ColorMapPresenterInterface {
    
    func didSelectMenuButton(at index: Int) {
        guard let mapLayer = ColorMapLayerType(rawValue: index) else { return }
        view.showMapLayer(layerType: mapLayer, annotations: nil)
        AppData.colorMapLayerItem = mapLayer.rawValue
    }
    
    func didSelectFilterButton() {
        wireframe.navigate(to: .pickerdialog)
    }
    
}
