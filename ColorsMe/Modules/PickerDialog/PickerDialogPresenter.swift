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
    func didSelectDoneButton() {
        wireframe.dismiss(animated: true)
    }
    
    func didSelectCancelButton() {
        wireframe.dismiss(animated: true)
    }
    
}
