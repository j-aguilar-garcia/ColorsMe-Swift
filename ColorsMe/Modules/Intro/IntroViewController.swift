//
//  IntroViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 23.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class IntroViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: IntroPresenterInterface!

    
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
        log.verbose(#function)
        presenter.didSelectAddAction(color: .Green)
    }
    
    @IBAction func onYellowDot(_ sender: Any) {
        log.verbose(#function)
        presenter.didSelectAddAction(color: .Yellow)
    }
    
    @IBAction func onRedDot(_ sender: Any) {
        log.verbose(#function)
        presenter.didSelectAddAction(color: .Red)
    }
    
    @IBAction func onSkipButton(_ sender: Any) {
        log.verbose(#function)
        presenter.didSelectSkipAction()
    }
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = DataManager.shared.dataManager(willRetrieveWith: .remote)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

}

// MARK: - Extensions -

extension IntroViewController: IntroViewInterface {
}
