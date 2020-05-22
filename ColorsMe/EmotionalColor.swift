//
//  EmotionalColor.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

enum EmotionalColor : String {
    case Green
    case Red
    case Yellow
}

extension EmotionalColor : Codable {
    enum CodinKeys: String, CodingKey {
        case Green
        case Red
        case Yellow
    }
}
