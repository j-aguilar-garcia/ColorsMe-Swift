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
        let interactor = IntroInteractor()
        let presenter = IntroPresenter(view: moduleViewController, wireframe: self, interactor: interactor)
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }

}

// MARK: - Extensions -

extension IntroWireframe: IntroWireframeInterface {
    func navigate(to option: IntroNavigationOption) {
        log.verbose(#function)
        switch option {
        case .colormap:
            openColorMap()
            break
        case .colormapwith(let annotation):
            openColorMap(with: annotation)
            break
        }
    }
    
    private func openColorMap() {
        log.verbose(#function)
        let tabBarWireframe = ColorTabBarWireframe()
        tabBarWireframe.installTabBar()
        switchRootWireframe(rootWireframe: tabBarWireframe, animated: true, completion: nil)
    }
    
    private func openColorMap(with annotation: CMAnnotation) {
        log.verbose(#function)
        let tabBarWireframe = ColorTabBarWireframe()
        tabBarWireframe.installTabBar(with: annotation)
        self.switchRootWireframe(rootWireframe: tabBarWireframe, animated: true, completion: nil)
        
    }
    
}
