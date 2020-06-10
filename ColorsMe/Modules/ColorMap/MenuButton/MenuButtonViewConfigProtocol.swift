//
//  MenuButtonViewConfigProtocol.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 27.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

public protocol MenuButtonViewConfigProtocol: class {
    var bgColor: UIColor { get set }
    var image: UIImage? { get set }
    var hasShadow: Bool { get set }
    var hapticFeedBackStyle: HapticFeedbackStyle { get set }
}

public enum HapticFeedbackStyle {
    case none
    case light
    case medium
    case heavy
}
