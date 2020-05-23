//
//  IntroInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 23.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

enum IntroNavigationOption {
    case colormap
    case colormapwith(EmotionalColor)
}

protocol IntroWireframeInterface: WireframeInterface {
    func navigate(to option: IntroNavigationOption)
}

protocol IntroViewInterface: ViewInterface {
}

protocol IntroPresenterInterface: PresenterInterface {
    func didSelectSkipAction()
    func didSelectAddAction(color: EmotionalColor)
}
