//
//  MenuButtonView.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 27.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

public protocol MenuButtonViewDelegate: class {
    func didSelectButton(_ buttonView: MenuButtonView)
}

public class MenuButtonView: UIView, MenuButtonViewConfigProtocol {
    
    public typealias BuildCellBlock = (MenuButtonViewConfigProtocol) -> Void
    
    public weak var delegate: MenuButtonViewDelegate?
    
    public var bgColor: UIColor = UIColor.white {
        didSet {
            backgroundColor = bgColor
        }
    }
    public var image: UIImage? {
        didSet {
            setupImageViewIfNeeded()
            updateImageView()
            
            layoutIfNeeded()
        }
    }
    public var hasShadow: Bool = true {
        didSet {
            hasShadow ? addShadow() : removeShadow()
            
            layoutIfNeeded()
        }
    }
    
    public var hapticFeedBackStyle: HapticFeedbackStyle = .light
    
    public var imgView: UIImageView?
    
    fileprivate let overlayView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    convenience public init(builder: BuildCellBlock) {
        self.init(frame: CGRect.zero)
        
        builder(self)
    }
    
    convenience public init(config: MenuButtonViewConfigProtocol) {
        self.init(frame: CGRect.zero)
        
        bgColor = config.bgColor
        image = config.image
        hasShadow = config.hasShadow
        hapticFeedBackStyle = config.hapticFeedBackStyle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // View Appearance
        layer.cornerRadius = bounds.width/2
        
        //Overlay Layer
        overlayView.frame = bounds
        overlayView.layer.cornerRadius = layer.cornerRadius
        
        // Image View
        imgView?.frame = bounds
        imgView?.layer.cornerRadius = layer.cornerRadius
        
        // Shadow
        setShadowOffset(false)
    }
    
    fileprivate func setup() {
        setupOverlayLayer()
    }
    
    fileprivate func setupOverlayLayer() {
        overlayView.backgroundColor = UIColor.clear
        overlayView.isUserInteractionEnabled = false
        addSubview(overlayView)
    }
    
    fileprivate func setupImageViewIfNeeded() {
        if imgView != nil { return }
        
        imgView = UIImageView(image: image)
        insertSubview(imgView!, belowSubview: overlayView)
    }
    
    fileprivate func updateImageView() {
        imgView?.image = image
        imgView?.contentMode = .scaleAspectFit
        imgView?.clipsToBounds = true
    }
    
    fileprivate func addShadow() {
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    fileprivate func removeShadow() {
        layer.shadowOpacity = 0
    }
    
    fileprivate func setShadowOffset(_ isSelected: Bool) {
        let shadowOffsetX = isSelected ? CGFloat(1) : CGFloat(5)
        let shadowOffsetY = isSelected ? CGFloat(0) : CGFloat(3)
        layer.shadowOffset = CGSize(width: bounds.origin.x + shadowOffsetX, height: bounds.origin.y + shadowOffsetY)
    }
    
    fileprivate func adjustAppearanceForStateSelected(_ selected: Bool) {
        setShadowOffset(selected)
        setOverlayColorForState(selected)
    }
    
    fileprivate func setOverlayColorForState(_ selected: Bool) {
        overlayView.backgroundColor = selected ? UIColor.black.withAlphaComponent(0.2) : UIColor.clear
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAppearanceForStateSelected(true)
        generateHapticFeedback(hapticFeedBackStyle)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAppearanceForStateSelected(false)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didSelectButton(self)
        adjustAppearanceForStateSelected(false)
    }
    
    fileprivate func generateHapticFeedback(_ style: HapticFeedbackStyle) {
        if style == .none {
            return
        }
        if style == .light {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } else if style == .medium {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } else if style == .heavy {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }

}
