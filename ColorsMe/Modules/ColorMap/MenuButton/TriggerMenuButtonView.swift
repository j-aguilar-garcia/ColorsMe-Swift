//
//  TriggerMenuButtonView.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 27.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

public class MenuTriggerButtonView: MenuButtonView {
    
    fileprivate var notHighlightedImageHolder: UIImage?
    fileprivate var highlightedImage: UIImage?
    
    public init(frame: CGRect, highlightedImage: UIImage) {
        self.highlightedImage = highlightedImage
        
        super.init(frame: frame)
    }
    
    convenience public init(highlightedImage: UIImage, builder: BuildCellBlock) {
        self.init(frame: CGRect.zero, highlightedImage: highlightedImage)
        
        builder(self)
    }
    
    convenience public init(highlightedImage: UIImage, config: MenuButtonViewConfigProtocol) {
        self.init(frame: CGRect.zero, highlightedImage: highlightedImage)
        
        bgColor = config.bgColor
        image = config.image
        hasShadow = config.hasShadow
        hapticFeedBackStyle = config.hapticFeedBackStyle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func markAsPressed(_ pressed: Bool) {
        if notHighlightedImageHolder == nil { notHighlightedImageHolder = image }
        
        image = pressed ? highlightedImage : notHighlightedImageHolder
    }
}
