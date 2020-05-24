//
//  PickerData.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

class PickerData {
    
    var value: String!
    var index: Int!
    var date: Date!
    
    init(value: String, index: Int, date: Date) {
        self.value = value
        self.index = index
        self.date = date
    }
    
    init(value: String, index: Int) {
        self.value = value
        self.index = index
    }
    
}
