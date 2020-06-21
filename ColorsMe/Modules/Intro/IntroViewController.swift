//
//  IntroViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 23.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import CoreLocation

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
    @IBOutlet weak var skipButton: UIButton!
    
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
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        navigationController?.navigationBar.isHidden = true
        updateConstraints()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateConstraints(animated: true)
    }
    
}

// MARK: - Extensions -

extension IntroViewController: IntroViewInterface {
    
    func animateSplashScreen(withDelay: Bool = true) {
        let commonAnimationDuration = TimeInterval(0.4)
        let commonSpringDumping = CGFloat(0.4)
        let commonInitSpringVelocity = CGFloat(0.1)
        
        var delay: TimeInterval = 0.0
        let colorButtons = [greenDotButton, yellowDotButton, redDotButton]
        
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
                    UIView.animate(withDuration: 0.3, animations:  {
                        button?.alpha = 1.0
                        button?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        button?.layoutIfNeeded()
                    }) { finish in
                        button?.isUserInteractionEnabled = true
                        if button == colorButtons.last {
                            UIView.animate(withDuration: 0.4, delay: delay, animations: {
                                self.skipButton.alpha = 1.0
                                self.skipButton.isUserInteractionEnabled = true
                                self.skipButton.layoutIfNeeded()
                                LocationService.default.startLocationRequest()
                            })
                        }
                    }
                }
                if withDelay {
                    delay += 0.1
                }
            }
        }
        
    }
    
    
    private func updateConstraints(animated: Bool = false) {
        if animated && UIDevice.current.userInterfaceIdiom == .pad {
            DispatchQueue.main.async {
                let colorButtons = [self.greenDotButton, self.yellowDotButton, self.redDotButton]
                for button in colorButtons {
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations:  {
                        button?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                        button?.alpha = 0
                        button?.layoutIfNeeded()
                        self.skipButton.alpha = 0
                        self.skipButton.layoutIfNeeded()
                    }) { finish in
                        UIView.animate(withDuration: 0.1, animations:  {
                            button?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            button?.layoutIfNeeded()
                        }) { finish in
                            if button == colorButtons.last {
                                self.animateSplashScreen(withDelay: false)
                            }
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let isLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
            
            if isPad && isLandscape {
                self.greenCenterY.priority = .required
                self.redCenterY.priority = .required
                self.greenDotTrailingToYellowLeadingConstraint.priority = .required
                self.yellowDotTrailingToRedDotLeadingConstraint.priority = .required
                self.greenDotBottomToYellowDotTopConstraint.priority = .defaultLow
                self.yellowDotBottomToRedDotTopConstraint.priority = .defaultLow
                self.greenCenterX.priority = .defaultLow
                self.redCenterX.priority = .defaultLow
                
            } else if isPad && !isLandscape {
                self.greenDotBottomToYellowDotTopConstraint.priority = .required
                self.yellowDotBottomToRedDotTopConstraint.priority = .required
                self.greenCenterX.priority = .required
                self.redCenterX.priority = .required
                self.greenCenterY.priority = .defaultLow
                self.redCenterY.priority = .defaultLow
                self.greenDotTrailingToYellowLeadingConstraint.priority = .defaultLow
                self.yellowDotTrailingToRedDotLeadingConstraint.priority = .defaultLow
            }
        }
    }
    
}
