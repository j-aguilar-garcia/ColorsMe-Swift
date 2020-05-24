//
//  ColorMapInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

enum ColorMapNavigationOption {
    case pickerdialog
}

protocol ColorMapWireframeInterface: WireframeInterface {
    func navigate(to option: ColorMapNavigationOption)
}

protocol ColorMapViewInterface: ViewInterface {
    func updateScale()
    func showScale(_ animated: Bool)
    func hideScale(_ animated: Bool)
    func switchMapViewAppearance()
}

protocol ColorMapPresenterInterface: PresenterInterface {
    func didSelectFilterButton()
}

protocol ColorMapInteractorInterface: InteractorInterface {
    
}
