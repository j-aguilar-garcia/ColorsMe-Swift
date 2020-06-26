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
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        presenter.didSelectCancelButton()
    }
    
    @IBAction func onDone(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        AppData.selectedFilterIndex = pickerView.selectedRow(inComponent: 0)
        presenter.didSelectDoneButton(with: AppData.selectedFilterIndex)
    }
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(AppData.selectedFilterIndex, inComponent: 0, animated: false)
        presenter.viewDidLoad()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let popover = self.popoverPresentationController {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height

            popover.sourceRect = CGRect(
                x: (width / 2) - (popover.sourceRect.width / 2),
                y: (height / 2) - (popover.sourceRect.height / 2),
                width: popover.sourceRect.width, height: popover.sourceRect.height)
        }
        super.viewWillTransition(to: size, with: coordinator)
    }


}

// MARK: - Extensions -

extension PickerDialogViewController: PickerDialogViewInterface {
    
    func addBorders() {
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.cmPolylineFill.cgColor
        bottomLine.frame = CGRect(x: 0, y: pickerView.frame.height - 1, width: pickerView.frame.width, height: 0.3)
        
        let topLine = CALayer()
        topLine.backgroundColor = UIColor.cmPolylineFill.cgColor
        topLine.frame = CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 0.3)
        
        pickerView.layer.addSublayer(bottomLine)
        pickerView.layer.addSublayer(topLine)
        
        let leftLine = CALayer()
        leftLine.backgroundColor = UIColor.cmPolylineFill.cgColor
        leftLine.frame = CGRect(x: 1, y: 0, width: 0.3, height: doneButton.frame.height)
        doneButton.layer.addSublayer(leftLine)
    }
    
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
    
}
