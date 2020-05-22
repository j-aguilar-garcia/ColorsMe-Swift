//
//  MainInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

enum MainNavigationOption {
    case colormap
    case colormapwith(EmotionalColor)
}

protocol MainWireframeInterface: WireframeInterface {
    func navigate(to option: MainNavigationOption)
}

protocol MainViewInterface: ViewInterface {
}

protocol MainPresenterInterface: PresenterInterface {
    func didSelectSkipAction()
    func didSelectAddColorAction(with color: EmotionalColor)
}
