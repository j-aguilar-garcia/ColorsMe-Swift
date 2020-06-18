//
//  SettingsWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class SettingsWireframe: BaseWireframe, TabBarViewProtocol {
    
    var tabIcon: UIImage = UIImage(named: "Settings")!
    var tabTitle: String = "Settings"
    

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Settings", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: SettingsViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension SettingsWireframe: SettingsWireframeInterface {
    
    func navigate(to option: SettingsNavigationOption) {
        switch option {
        case .textview(let item):
            let vc = storyboard.instantiateViewController(ofType: TextViewViewController.self)
            vc.navigationItem.title = item.navigationTitle
            vc.pageType = item.pageType
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
