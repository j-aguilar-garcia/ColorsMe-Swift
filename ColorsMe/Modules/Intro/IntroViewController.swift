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
    
    @IBOutlet weak var greenDotButton: UIButton!
    @IBOutlet weak var yellowDotButton: UIButton!
    @IBOutlet weak var redDotButton: UIButton!
    @IBOutlet weak var splashScreenImageView: UIImageView!
    
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
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

}

// MARK: - Extensions -

extension IntroViewController: IntroViewInterface {
    
    func animateSplashScreen() {
        let commonAnimationDuration = TimeInterval(0.4)
        let commonSpringDumping = CGFloat(0.4)
        let commonInitSpringVelocity = CGFloat(0.1)
        
        var delay: TimeInterval = 0.0
        let colorButtons = [greenDotButton, yellowDotButton, redDotButton]
        greenDotButton.alpha = 0
        yellowDotButton.alpha = 0
        redDotButton.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.splashScreenImageView?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.splashScreenImageView?.alpha = 0.0
            self.splashScreenImageView?.layoutIfNeeded()
        }) { finish in
            for button in colorButtons {
                UIView.animate(withDuration: commonAnimationDuration, delay: delay, usingSpringWithDamping: commonSpringDumping, initialSpringVelocity: commonInitSpringVelocity, options: .curveEaseOut, animations: {
                    button?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                    button?.layoutIfNeeded()
                }) { finish in
                    UIView.animate(withDuration: 0.3) {
                        button?.alpha = 1.0
                        button?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        button?.layoutIfNeeded()
                    }
                }
                delay += 0.1
            }
        }
    }
    
}
