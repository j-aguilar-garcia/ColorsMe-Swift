//
//  EmotionalDiaryInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

protocol EmotionalDiaryWireframeInterface: WireframeInterface {
    
}

protocol EmotionalDiaryViewInterface: ViewInterface {
    func reloadTableView()
}

protocol EmotionalDiaryPresenterInterface: PresenterInterface {
    var sections : [Section<MyColorsItem>] { get }
}

protocol EmotionalDiaryInteractorInterface: InteractorInterface {
    
}

enum MyColorsItem {
    case myColors(CMAnnotation)
}
