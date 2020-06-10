//
//  MenuButtonAnimator.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 27.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit


public protocol MenuSideButtonAnimatorProtocol {
    func animateTriggerButton(_ button: MenuButtonView, state: MenuButtonState, completition: (() -> ())?)
    func animateButtonsPositionX(_ buttonsArr: [MenuButtonView], targetPos: CGPoint, completition: (() -> ())?)
}


struct MenuSideButtonAnimator {
    
    let commonAnimationDuration = TimeInterval(0.4)
    let commonSpringDumping = CGFloat(0.4)
    let commonInitSpringVelocity = CGFloat(0.1)
    
    fileprivate func commonAnimation(_ delay: TimeInterval = 0, animations: @escaping () -> (), completition: ((Bool) -> ())? = nil) {
        UIView.animate(withDuration: commonAnimationDuration, delay: delay, usingSpringWithDamping: commonSpringDumping, initialSpringVelocity: commonInitSpringVelocity, options: .curveEaseOut, animations: animations, completion: completition)
    }
}


extension MenuSideButtonAnimator: MenuSideButtonAnimatorProtocol {
    
    func animateTriggerButton(_ button: MenuButtonView, state: MenuButtonState, completition: (() -> ())?) {
        let scale = state == .hidden ? CGFloat(1) : CGFloat (0.7)
        let trans = CGAffineTransform(scaleX: scale, y: scale)
        
        commonAnimation(animations: {
            button.transform = trans
        }) { finish in
            if finish { completition?() }
        }
    }
    
    func animateButtonsPositionX(_ buttonsArr: [MenuButtonView], targetPos: CGPoint, completition: (() -> ())? = nil) {
        
        var delay: TimeInterval = 0
        for button in buttonsArr {
            let completitionBlock = button.isEqual(buttonsArr.last) ? completition : nil
            
            commonAnimation(delay, animations: {
                button.frame = CGRect(origin: CGPoint(x: targetPos.x, y: button.frame.origin.y), size: button.bounds.size)
                
            }) { finish in
                if finish { completitionBlock?() }
            }
            
            delay += 0.1
        }
    }
}
