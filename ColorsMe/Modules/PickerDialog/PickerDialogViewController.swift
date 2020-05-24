//
//  PickerDialogViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class PickerDialogViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: PickerDialogPresenterInterface!

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func onCancel(_ sender: Any) {
        presenter.didSelectCancelButton()
    }
    
    @IBAction func onDone(_ sender: Any) {
        presenter.didSelectDoneButton()
    }
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }

}

// MARK: - Extensions -

extension PickerDialogViewController: PickerDialogViewInterface {
}


// MARK: - UIPickerViewDelegate
extension PickerDialogViewController : UIPickerViewDelegate {
    
}

// MARK: - UIPickerViewDataSource
extension PickerDialogViewController : UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.pickerData[row].value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //AppData.selectedFilterIndex = row
        //updatePickerView(row: row)
        //colorMapViewController.updateSlider()
    }
    
}
