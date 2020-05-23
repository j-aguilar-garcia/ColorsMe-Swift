//
//  ColorTabBarPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

final class ColorTabBarPresenter {

    // MARK: - Private properties -

    private unowned let view: ColorTabBarViewInterface
    private let wireframe: ColorTabBarWireframeInterface

    // MARK: - Lifecycle -

    init(view: ColorTabBarViewInterface, wireframe: ColorTabBarWireframeInterface) {
        self.view = view
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension ColorTabBarPresenter: ColorTabBarPresenterInterface {
}
