
//
//  CMBorderedLabel.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 18.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

class CMBorderedLabel : UILabel {
    
    var borderedText: String = "" {
        willSet(value) {
            let attributes = [
                NSAttributedString.Key.strokeColor : UIColor.black,
                NSAttributedString.Key.foregroundColor : UIColor.label,
                NSAttributedString.Key.strokeWidth : -4.0,
                NSAttributedString.Key.font : UIFont.bold(ofSize: UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? 17 : 17)]
                as [NSAttributedString.Key : Any]

            attributedText = NSMutableAttributedString(string: value, attributes: attributes)
        }
    }
    
}
