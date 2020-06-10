//
//  Section.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

struct Section<T> {
    
    var header: String?
    var footer: String?
    var items: [T] = []

    init(items: [T]) {
        self.items = items
    }
    
}

