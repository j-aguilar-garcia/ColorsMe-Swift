//
//  PickerDialogWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class PickerDialogWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "PickerDialog", bundle: nil)

    var delegate: PickerDialogDelegate?
    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: PickerDialogViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = PickerDialogInteractor()
        let presenter = PickerDialogPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
        moduleViewController.modalTransitionStyle = .crossDissolve
        moduleViewController.modalPresentationStyle = .popover
    }

}

// MARK: - Extensions -

extension PickerDialogWireframe: PickerDialogWireframeInterface {
    func navigate(with option: PickerDialogFilterOption) {
        let annotations = DataManager.shared.dataManager(filterBy: option, with: .local, completion: nil)
        delegate?.pickerDialogDidChange(with: option, annotations: annotations)
        self.dismiss(animated: true)
    }
    
    func navigate() {
        delegate?.pickerDialogDidClose()
        self.dismiss(animated: true)
    }
    
}
