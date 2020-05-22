//
//  MainViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: MainPresenterInterface!
    
    // Portrait Constraints for iPad
    
    @IBOutlet weak var greenDotBottomToYellowDotTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var yellowDotBottomToRedDotTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var greenCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var redCenterX: NSLayoutConstraint!
    
    
    // Landscape Constraints for iPad
    
    @IBOutlet weak var greenCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var redCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var greenDotTrailingToYellowLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var yellowDotTrailingToRedDotLeadingConstraint: NSLayoutConstraint!
    
    
    // Actions
    
    @IBAction func onGreenDot(_ sender: Any) {
        presenter.didSelectAddColorAction(with: .Green)
    }
    
    @IBAction func onYellowDot(_ sender: Any) {
        presenter.didSelectAddColorAction(with: .Yellow)
    }
    
    @IBAction func onRedDot(_ sender: Any) {
        presenter.didSelectAddColorAction(with: .Red)
    }
    
    @IBAction func onSkipButton(_ sender: Any) {
        presenter.didSelectSkipAction()
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Extensions -

extension MainViewController: MainViewInterface {
}
