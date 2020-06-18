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
    case colormapwith(CMAnnotation)
}

protocol IntroWireframeInterface: WireframeInterface {
    func navigate(to option: IntroNavigationOption)
}

protocol IntroViewInterface: ViewInterface {
    func animateSplashScreen(withDelay: Bool)
}

protocol IntroInteractorInterface: InteractorInterface {
    func createAnnotation(with color: EmotionalColor)
}

protocol IntroPresenterInterface: PresenterInterface {
    func didSelectSkipAction()
    func didSelectAddAction(color: EmotionalColor)
    func didCreateAnnotation(annotation: CMAnnotation)
}
