//
//  ColorMapWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class ColorMapWireframe: BaseWireframe, TabBarViewProtocol {
    
    var tabIcon: UIImage = UIImage(named: "")!
    var tabTitle: String = "ColorMap"
    
    func configuredViewController() -> UIViewController {
        let moduleViewController = storyboard.instantiateViewController(ofType: ColorMapViewController.self)
        
        let interactor = ColorMapInteractor()
        let presenter = ColorMapPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
        
        return moduleViewController
    }
    

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "ColorMap", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: ColorMapViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = ColorMapInteractor()
        let presenter = ColorMapPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension ColorMapWireframe: ColorMapWireframeInterface {
}
