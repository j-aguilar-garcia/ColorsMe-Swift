//
//  PickerDialogPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

final class PickerDialogPresenter {

    // MARK: - Private properties -

    private unowned let view: PickerDialogViewInterface
    private let interactor: PickerDialogInteractorInterface
    private let wireframe: PickerDialogWireframeInterface
    var delegate: PickerDialogDelegate?
    
    var pickerData = [
        PickerData.init(value: "All Colors", index: 0),
        PickerData.init(value: "My Colors", index: 1),
        PickerData.init(value: "Today", index: 2),
        PickerData.init(value: "Yesterday", index: 3),
        PickerData.init(value: "Last week", index: 4)
    ]
    
    // MARK: - Lifecycle -

    init(view: PickerDialogViewInterface, interactor: PickerDialogInteractorInterface, wireframe: PickerDialogWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        pickerData = interactor.getYears(pickerData: pickerData)
        pickerData = interactor.getMonths(pickerData: pickerData)
    }
}

// MARK: - Extensions -

extension PickerDialogPresenter: PickerDialogPresenterInterface {
    
    func didSelectDoneButton(with row: Int) {
        AppData.selectedFilterName = pickerData[row].value
        if row == 0 {
            wireframe.navigate(with: .allcolors)
        } else if row == 1 {
            wireframe.navigate(with: .mycolors)
        } else if row == 2 {
            wireframe.navigate(with: .today)
        } else if row == 3 {
            wireframe.navigate(with: .yesterday)
        } else if row == 4 {
            wireframe.navigate(with: .lastweek)
        } else if pickerData[row].value.count == 4 && pickerData[row].value.starts(with: "20") {
            let date = pickerData[row].date
            wireframe.navigate(with: .year(date!))
        } else {
            let date = pickerData[row].date
            wireframe.navigate(with: .month(date!))
        }
    }
    
    func didSelectCancelButton() {
        wireframe.navigate()
    }
    
}
