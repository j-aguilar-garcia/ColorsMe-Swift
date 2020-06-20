//
//  Color.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 28.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public class var cmAppDefaultColor : UIColor {
        return UIColor(named: "CMAppDefaultColor")!
    }
    
    public class var cmGreen : UIColor {
        return UIColor(named: "CMGreen")!
    }
    
    public class var cmYellow : UIColor {
        return UIColor(named: "CMYellow")!
    }
    
    public class var cmRed : UIColor {
        return UIColor(named: "CMRed")!
    }
    
    public class var cmClusterImage : UIColor {
        return UIColor(named: "CMClusterImageColor")!
    }
    
    // MARK: - Map Overlay Colors
    public class var cmPolylineStroke : UIColor {
        return UIColor(named: "PolylineStroke")!
    }
    
    public class var cmPolylineFill : UIColor {
        return UIColor(named: "PolylineFill")!
    }
    
    // MARK: - Heatmap Colors
    public class var cmHeatmapOne : UIColor {
        return UIColor(named: "CMHeatmapOne")!
    }
    
    public class var cmHeatmapTwo : UIColor {
        return UIColor(named: "CMHeatmapTwo")!
    }
    
    public class var cmHeatmapThree : UIColor {
        return UIColor(named: "CMHeatmapThree")!
    }
    
    public class var cmHeatmapFour : UIColor {
        return UIColor(named: "CMHeatmapFour")!
    }
    
    public class var cmHeatmapFive : UIColor {
        return UIColor(named: "CMHeatmapFive")!
    }
    
    public class var cmHeatmapSix : UIColor {
        return UIColor(named: "CMHeatmapSix")!
    }
    
    // CMBorderdLabel
    public class var cmBorderedStroke : UIColor {
        return UIColor(named: "CMBorderedStrokeColor")!
    }
    
    public class var cmBorderedForeground : UIColor {
        return UIColor(named: "CMBorderedForegroundColor")!
    }
}
