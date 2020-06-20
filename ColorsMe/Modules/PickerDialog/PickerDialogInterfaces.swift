//
//  PickerDialogInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

enum PickerDialogFilterOption {
    case allcolors
    case mycolors
    case today
    case yesterday
    case lastweek
    case year(Date)
    case month(Date)
}

protocol PickerDialogWireframeInterface: WireframeInterface {
    func navigate()
    func navigate(with option: PickerDialogFilterOption)
}

protocol PickerDialogViewInterface: ViewInterface {
    func addBorders()
}

protocol PickerDialogPresenterInterface: PresenterInterface {
    func didSelectDoneButton(with row: Int)
    func didSelectCancelButton()
    var pickerData: [PickerData] { get }
}

protocol PickerDialogInteractorInterface: InteractorInterface {
    func getYears(pickerData: [PickerData]) -> [PickerData]
    func getMonths(pickerData: [PickerData]) -> [PickerData]
}
