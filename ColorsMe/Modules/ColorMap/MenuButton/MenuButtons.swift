//
//  MenuButton.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 27.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

public protocol MenuSideButtonsDelegate: class {
    func sideButtons(_ sideButtons: MenuSideButtons, didSelectButtonAtIndex index: Int)
    func sideButtons(_ sideButtons: MenuSideButtons, didTriggerButtonChangeStateTo state: MenuButtonState)
}

public protocol MenuSideButtonsDataSource: class {
    func sideButtonsNumberOfButtons(_ sideButtons: MenuSideButtons) -> Int
    func sideButtons(_ sideButtons: MenuSideButtons, buttonAtIndex index: Int) -> MenuButtonView
}

public enum MenuButtonState: Int {
    case hidden = 0
    case shown
}

public class MenuSideButtons {
    
    public weak var parentView: UIView?
    public weak var delegate: MenuSideButtonsDelegate?
    public weak var dataSource: MenuSideButtonsDataSource?

    fileprivate let buttonSize = CGSize(width: 55, height: 55)
    fileprivate let verticalSpacing = CGFloat(30)
    fileprivate var hideStateOffset: CGFloat {
        get {
            guard let parentView = parentView else { return 0 }
            
            let parentViewWidth = parentView.bounds.width
            let hideOffsetX = buttonSize.width * (3/2)
            var resultPosX = parentViewWidth + hideOffsetX
            if (triggerButton.frame.origin.x + buttonSize.width/2 < parentViewWidth / 2) {
                resultPosX = -(hideOffsetX + buttonSize.width)
            }
            
            return resultPosX
        }
    }
    
    fileprivate var buttonsArr = [MenuButtonView]()
    fileprivate let buttonsAnimator: MenuSideButtonAnimatorProtocol
    fileprivate var descriptionArr = [String]()
    
    fileprivate(set) var state: MenuButtonState = .hidden {
        didSet {
            aniamateButtonForState(state) {}
            markTriggerButtonAsPressed(state == .shown)
            buttonsAnimator.animateTriggerButton(triggerButton, state: state) {}
        }
    }
    
    public var triggerButton: MenuTriggerButtonView!
    
    public init(parentView: UIView, triggerButton: MenuTriggerButtonView, buttonsAnimator: MenuSideButtonAnimatorProtocol) {
        self.parentView = parentView
        self.triggerButton = triggerButton
        self.buttonsAnimator = buttonsAnimator
        
        setup()
    }
    
    convenience public init(parentView: UIView, triggerButton: MenuTriggerButtonView) {
        // At this moment "MenuSideButtonAnimator" is only existing and default button animator
        self.init(parentView: parentView, triggerButton: triggerButton, buttonsAnimator: MenuSideButtonAnimator())
    }
    
    fileprivate func setup() {
        setDefaultTriggerButtonPosition()
        setupTriggerButton()
        layoutButtons()
    }
    
    fileprivate func setupTriggerButton() {
        guard let parentView = parentView else { return }

        setDefaultTriggerButtonPosition()
        triggerButton.delegate = self
        
        parentView.addSubview(triggerButton)
        parentView.bringSubviewToFront(triggerButton)
    }
    
    fileprivate func setDefaultTriggerButtonPosition() {
        guard let parentView = parentView else { return }
        
        triggerButton.frame = CGRect(x: parentView.bounds.width - buttonSize.width, y: parentView.bounds.height - buttonSize.height, width: buttonSize.width, height: buttonSize.height)
    }
    
    fileprivate func markTriggerButtonAsPressed(_ pressed: Bool) {
        triggerButton.markAsPressed(pressed)
    }
    
    fileprivate func layoutButtons() {
        var prevButton: MenuButtonView? = nil
        for button in buttonsArr {
            var buttonPosY = CGFloat(0)
            if let prevButton = prevButton {
                buttonPosY = prevButton.frame.minY - verticalSpacing - buttonSize.height
            } else {
                // Spacing has to be applied to prevent jumping rest of buttons
                let spacingFromTriggerButtonY = CGFloat(18) // TODO add offset according to scale
                buttonPosY = triggerButton.frame.midY - spacingFromTriggerButtonY - verticalSpacing - buttonSize.height
            }

            let buttonPosX = getButtonPoxXAccordingToState(state)
            // Buttons should be laid out according to center of trigger button
            button.frame = CGRect(origin: CGPoint(x: buttonPosX, y: buttonPosY), size: buttonSize)
            
            prevButton = button
        }
    }

    fileprivate func getButtonPoxXAccordingToState(_ state: MenuButtonState) -> CGFloat {
        return state == .hidden ? hideStateOffset : triggerButton.frame.midX - buttonSize.width/2
    }
    
    fileprivate func removeButtons() {
        _ = buttonsArr.map{ $0.removeFromSuperview() }
        buttonsArr.removeAll()
    }
    
    fileprivate func addButtons() {
        guard let numberOfButtons = dataSource?.sideButtonsNumberOfButtons(self) else { return }
        
        for index in 0..<numberOfButtons {
            guard let button = dataSource?.sideButtons(self, buttonAtIndex: index) else { return }
            
            button.delegate = self
            parentView?.addSubview(button)
            parentView?.bringSubviewToFront(button)
            buttonsArr.append(button)
        }
    }
    
    fileprivate func aniamateButtonForState(_ state: MenuButtonState, completition: (() -> ())? = nil) {
        let buttonPosX = getButtonPoxXAccordingToState(state)
        let targetPoint = CGPoint(x: buttonPosX, y: 0)
        
        buttonsAnimator.animateButtonsPositionX(buttonsArr, targetPos: targetPoint, completition: completition)
    }
    
    /**
     Method reload whole buttons. Use this method right after you made some changes in Side Buttons model.
     */
    public func reloadButtons() {
        removeButtons()
        addButtons()
        layoutButtons()
    }
    
    /**
     Use this method for positioning of trigger button (should be invoken right after your view of ViewController is loaded and has proper frame).
     
     - parameter position: position of right button, have in mind that if you set position of trigger button you need to substract/add his width or height (it depends on position in view axis)
     */
    public func setTriggerButtonPosition(_ position: CGPoint) {
        let scale = state == .hidden ? CGFloat(1) : CGFloat (0.5)
        let offset = triggerButton.frame.size.width/2 * scale
        let newPosition = state == .hidden ? position : CGPoint(x: position.x + offset, y: position.y + offset)
        triggerButton.frame = CGRect(origin: newPosition, size: triggerButton.frame.size)
        
        reloadButtons()
    }
    
    /**
     If you want to hide trigger button in some point of lifecycle of your VC you can using this method
     */
    public func hideTriggerButton() {
        hideButtons()
        triggerButton.isHidden = true
    }
    
    /**
     Method shows trigger button (if was hidden before)
     */
    public func showTriggerButton() {
        hideButtons()
        triggerButton.isHidden = false
    }
    
    /**
     Method show with animation all side buttons
     */
    public func showButtons() {
        state = .shown
    }
    
    /**
     Method hide with animation all side buttons
     */
    public func hideButtons() {
        state = .hidden
    }
}

extension MenuSideButtons: MenuButtonViewDelegate {
    
    public func didSelectButton(_ buttonView: MenuButtonView) {
        if let indexOfButton = buttonsArr.firstIndex(of: buttonView) {
            delegate?.sideButtons(self, didSelectButtonAtIndex: indexOfButton)
           
            state = .hidden
        } else {
            state = state == .shown ? .hidden : .shown
            
            delegate?.sideButtons(self, didTriggerButtonChangeStateTo: state)
        }
    }
}
