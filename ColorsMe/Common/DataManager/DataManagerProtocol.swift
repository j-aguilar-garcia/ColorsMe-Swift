//
//  DataManagerProtocol.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 25.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    
    func add<T>(value: T)
    func add<T>(values: [T])
    func update<T>(value: T)
    func deleteById<T>(value: T, type: T)

    func all<T>() -> [T]
    func findById<T>(id: String) -> T
    
    
}
