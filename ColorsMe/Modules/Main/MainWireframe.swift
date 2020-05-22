//
//  MainWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class MainWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: MainViewController.self)
        super.init(viewController: moduleViewController)

        let presenter = MainPresenter(view: moduleViewController, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension MainWireframe: MainWireframeInterface {
    func navigate(to option: MainNavigationOption) {
        switch option {
        case .colormap:
            presentColorMap()
            break
        case .colormapwith(let color):
            presentColorMap(with: color)
            break
        }
    }
    
    private func presentColorMap() {
        // MARK: - TODO 
    }
    
    private func presentColorMap(with color: EmotionalColor) {
        
    }
    
}
