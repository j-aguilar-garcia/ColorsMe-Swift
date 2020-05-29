//
//  Font.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 29.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
  
    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Regular", size: size)!
    }
    
    class func thin(ofSize size: CGFloat) -> UIFont {
      return UIFont(name: "HelveticaNeue-Thin", size: size)!
    }
    
    class func light(ofSize size: CGFloat) -> UIFont {
      return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
    
    
}
