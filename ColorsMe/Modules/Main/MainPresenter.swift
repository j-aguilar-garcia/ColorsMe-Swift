//
//  MainPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

final class MainPresenter {

    // MARK: - Private properties -

    private unowned let view: MainViewInterface
    private let wireframe: MainWireframeInterface

    // MARK: - Lifecycle -

    init(view: MainViewInterface, wireframe: MainWireframeInterface) {
        self.view = view
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension MainPresenter: MainPresenterInterface {
    func didSelectSkipAction() {
        wireframe.navigate(to: .colormap)
    }
    
    func didSelectAddColorAction(with color: EmotionalColor) {
        wireframe.navigate(to: .colormapwith(color))
    }
    
}
