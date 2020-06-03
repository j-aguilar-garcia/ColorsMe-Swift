//
//  View.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow() {
        
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.cornerRadius = 20
        layer.shadowRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = false
    }
    
    func setCorner(radius: CGFloat = 20) {
        layer.cornerRadius = 20
    }
    
    
}
