//
//  DateFormat.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let yyyyMMddHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.isLenient = true
        return formatter
    }()
    
    static let yyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static let ddMMyyyy: DateFormatter = {
       let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter
    }()
    
    static let MMMddyyyyHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        return formatter
    }()
    
    static let MMMddyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    static let MMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM YYYY"
        return formatter
    }()
    
    static let HHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
}