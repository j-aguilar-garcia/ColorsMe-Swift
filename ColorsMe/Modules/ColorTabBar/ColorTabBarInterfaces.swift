//
//  ColorTabBarInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

protocol ColorTabBarWireframeInterface: WireframeInterface {
    func installTabBar(with color: EmotionalColor?)
}

protocol ColorTabBarViewInterface: ViewInterface {
}

protocol ColorTabBarPresenterInterface: PresenterInterface {
}
