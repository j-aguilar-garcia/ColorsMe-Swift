//
//  IntroPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 23.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

final class IntroPresenter {

    // MARK: - Private properties -

    private unowned let view: IntroViewInterface
    private let wireframe: IntroWireframeInterface

    // MARK: - Lifecycle -

    init(view: IntroViewInterface, wireframe: IntroWireframeInterface) {
        self.view = view
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension IntroPresenter: IntroPresenterInterface {
    
    func viewDidLoad() {
        view.animateSplashScreen()
    }
    
    func didSelectSkipAction() {
        log.verbose(#function)
        wireframe.navigate(to: .colormap)
    }
    
    func didSelectAddAction(color: EmotionalColor) {
        log.verbose(#function)
        wireframe.navigate(to: .colormapwith(color))
    }
    
}
