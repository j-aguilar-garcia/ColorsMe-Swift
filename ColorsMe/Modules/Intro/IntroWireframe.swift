//
//  IntroWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 23.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class IntroWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Intro", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: IntroViewController.self)
        super.init(viewController: moduleViewController)
        log.verbose("")
        let presenter = IntroPresenter(view: moduleViewController, wireframe: self)
        moduleViewController.presenter = presenter
        log.warning(moduleViewController.presenter)
    }

}

// MARK: - Extensions -

extension IntroWireframe: IntroWireframeInterface {
    func navigate(to option: IntroNavigationOption) {
        switch option {
        case .colormap:
            openColorMap()
            break
        case .colormapwith(let color):
            openColorMap(with: color)
            break
        }
    }
    
    private func openColorMap() {
        let tabBarWireframe = ColorTabBarWireframe()
        self.viewController.presentWireframe(tabBarWireframe)
    }
    
    private func openColorMap(with color: EmotionalColor) {
        
    }
    
}
