//
//  ColorMapViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class ColorMapViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: ColorMapPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Extensions -

extension ColorMapViewController: ColorMapViewInterface {
}
