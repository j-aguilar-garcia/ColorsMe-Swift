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
    
    func installTabBar(with color: EmotionalColor?) {
        guard let color = color else {
             
            //var colorMapWireframe = ColorMapWireFrame()
            //var emotionalDiaryWireframe = EmotionalDiaryWireFrame()
            //var settingsWireframe = SettingsWireFrame()
            
            //var wireframes = [colorMapWireframe, emotionalDiaryWireframe, settingsWireframe]
            
            return
        }
    }
    
    
}
