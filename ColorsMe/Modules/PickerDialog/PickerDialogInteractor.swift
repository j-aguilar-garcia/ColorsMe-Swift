//
//  PickerDialogInteractor.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

final class PickerDialogInteractor {
}

// MARK: - Extensions -

extension PickerDialogInteractor: PickerDialogInteractorInterface {
    
    func getYears(pickerData: [PickerData]) -> [PickerData] {
        var data = pickerData
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.date(from: DateComponents(year: 2019, month: 1, day: 1))!
        let differenceYear = calendar.dateComponents([.year], from: startDate, to: today)
        let dateRangeFormatter = DateFormatter.yyyy
        
        for i in 0 ... differenceYear.year! {
            guard let date = calendar.date(byAdding: .year, value: -i, to: today) else { continue }

            let formattedDate = dateRangeFormatter.string(from: date)
            data.append(PickerData(value: formattedDate, index: data.count + i, date: date))
        }
        return data
    }
    
    func getMonths(pickerData: [PickerData]) -> [PickerData] {
        var data = pickerData
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.date(from: DateComponents(year: 2019, month: 1, day: 1))!
        let differenceMonth = calendar.dateComponents([.month], from: startDate, to: today)
        let dateRangeFormatter = DateFormatter.MMMyyyy
        
        for i in 0 ... differenceMonth.month! {
            guard let date = calendar.date(byAdding: .month, value: -i, to: today) else { continue }

            let formattedDate = dateRangeFormatter.string(from: date)
            data.append(PickerData(value: formattedDate, index: data.count + i, date: date))
        }
        return data
    }
    
}
