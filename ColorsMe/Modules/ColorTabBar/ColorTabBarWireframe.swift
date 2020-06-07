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
    
    func installTabBar(with annotation: CMAnnotation) {
        log.verbose(#function)
        
            //log.debug("installTabBar annotation saved: \(annotation.objectId) && guid \(annotation.guid)")
            let colorMapWireframe = ColorMapWireframe(annotation: annotation)
            let emotionalDiaryWireframe = EmotionalDiaryWireframe()
            var settingsWireframe = SettingsWireframe()

            // Setup delegate
            emotionalDiaryWireframe.delegate = colorMapWireframe.viewController as? EmotionalDiaryDelegate
            
            let wireframes : [BaseWireframe & TabBarViewProtocol] =
                [colorMapWireframe, emotionalDiaryWireframe, settingsWireframe]
            
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
    
    func installTabBar() {
        log.verbose(#function)
        
        let colorMapWireframe = ColorMapWireframe()
        let emotionalDiaryWireframe = EmotionalDiaryWireframe()
        var settingsWireframe = SettingsWireframe()
        
        // Setup delegate
        emotionalDiaryWireframe.delegate = colorMapWireframe.viewController as? EmotionalDiaryDelegate
        
        let wireframes : [BaseWireframe & TabBarViewProtocol] =
            [colorMapWireframe, emotionalDiaryWireframe, settingsWireframe]
        
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
