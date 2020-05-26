//
//  ColorTabBarWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class ColorTabBarWireframe: BaseWireframe {
    
    // MARK: - Private properties -
    
    private let storyboard = UIStoryboard(name: "ColorTabBar", bundle: nil)
    
    // MARK: - Module setup -
    
    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: ColorTabBarViewController.self)
        super.init(viewController: moduleViewController)
        
        let presenter = ColorTabBarPresenter(view: moduleViewController, wireframe: self)
        moduleViewController.presenter = presenter
    }
    
}

// MARK: - Extensions -

extension ColorTabBarWireframe: ColorTabBarWireframeInterface {
    
    func installTabBar(with color: EmotionalColor? = nil) {
        log.verbose(#function)
        let colorMapWireframe = ColorMapWireframe()
        //var emotionalDiaryWireframe = EmotionalDiaryWireFrame()
        //var settingsWireframe = SettingsWireFrame()
        
        let wireframes = [colorMapWireframe] //, emotionalDiaryWireframe, settingsWireframe]
        
        var viewControllers = [UIViewController]()
        
        for wireFrame in wireframes {
            let tabBarItem = UITabBarItem()
            tabBarItem.image = wireFrame.tabIcon
            tabBarItem.title = wireFrame.tabTitle
            
            let navigationController = UINavigationController()
            navigationController.setRootWireframe(wireFrame)
            navigationController.tabBarItem = tabBarItem

            viewControllers.append(navigationController)
        }
        
        if let controller = self.viewController as? ColorTabBarViewController {
            controller.viewControllers = viewControllers
        }
    }
    
    
}
