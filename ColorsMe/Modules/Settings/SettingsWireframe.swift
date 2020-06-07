//
//  SettingsWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import Firebase

final class SettingsWireframe: BaseWireframe, TabBarViewProtocol {
    
    var tabIcon: UIImage = UIImage(named: "Settings")!
    var tabTitle: String = "Settings"
    

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Settings", bundle: nil)
    private var firebaseConfig: FirebaseConfig!

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: SettingsViewController.self)
        super.init(viewController: moduleViewController)

        let presenter = SettingsPresenter(view: moduleViewController, wireframe: self)
        moduleViewController.presenter = presenter
        firebaseConfig = FirebaseConfig.shared
    }

}

// MARK: - Extensions -

extension SettingsWireframe: SettingsWireframeInterface {
    
    func navigate(to option: SettingsNavigationOption) {
        switch option {
        case .textview(let item):
            let vc = storyboard.instantiateViewController(ofType: TextViewViewController.self)
            vc.key = item.remoteConfigKey
            vc.remoteConfig = firebaseConfig.remoteConfig
            vc.navigationItem.title = item.navigationTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
