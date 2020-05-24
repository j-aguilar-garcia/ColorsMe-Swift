//
//  PickerDialogInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

protocol PickerDialogWireframeInterface: WireframeInterface {
    func navigate()
}

protocol PickerDialogViewInterface: ViewInterface {
}

protocol PickerDialogPresenterInterface: PresenterInterface {
    func didSelectDoneButton()
    func didSelectCancelButton()
    var pickerData: [PickerData] { get }
}

protocol PickerDialogInteractorInterface: InteractorInterface {
    func getYears(pickerData: [PickerData]) -> [PickerData]
    func getMonths(pickerData: [PickerData]) -> [PickerData]
}
