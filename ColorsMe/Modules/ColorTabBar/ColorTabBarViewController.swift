//
//  ColorTabBarViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class ColorTabBarViewController: UITabBarController {

    // MARK: - Public properties -

    var presenter: ColorTabBarPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Extensions -

extension ColorTabBarViewController: ColorTabBarViewInterface {
}
