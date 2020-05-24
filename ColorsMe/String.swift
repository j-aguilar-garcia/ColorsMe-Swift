//
//  String.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

extension String {
    
    func convertDate() -> String {
        var formatter = DateFormatter.yyyyMMddHHmmss
        let date = formatter.date(from: self)
        formatter = DateFormatter.MMMddyyyy
        let nwd = formatter.string(from: date!)
        return nwd
    }
    
    func convertToDate() -> Date? {
        let formatter = DateFormatter.yyyyMMddHHmmss
        let date = formatter.date(from: self)
        return date
    }
    
    func convertTime() -> String {
        var formatter = DateFormatter.yyyyMMddHHmmss
        let date = formatter.date(from: self)
        formatter = DateFormatter.HHmmss
        let nwd = formatter.string(from: date!)
        return nwd
    }
    
}
