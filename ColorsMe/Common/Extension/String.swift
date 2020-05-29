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
    
    func generateTimeBasedUUID() -> String? {
        let uuidSize = MemoryLayout<uuid_t>.size
        let uuidStringSize = MemoryLayout<uuid_string_t>.size
        let uuidPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: uuidSize)
        let uuidStringPointer = UnsafeMutablePointer<Int8>.allocate(capacity: uuidStringSize)
        uuid_generate_time(uuidPointer)
        uuid_unparse(uuidPointer, uuidStringPointer)
        let uuidString = NSString(utf8String: uuidStringPointer) as String?
        uuidPointer.deallocate()
        uuidStringPointer.deallocate()
        return uuidString
    }
    
}
