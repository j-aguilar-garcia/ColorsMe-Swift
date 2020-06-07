//
//  SettingsSnapshotTableViewCell.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

protocol SettingsSnapshotCellDelegate : class {
    func handleSnapshotsSwitchState(isOn: Bool)
}

class SettingsSnapshotTableViewCell: UITableViewCell {
    
    weak var delegate: SettingsSnapshotCellDelegate?

    @IBOutlet weak var allowSnapshotsSwitch: UISwitch!
    
    @IBAction func onSnapshotsSwitch(_ sender: Any) {
        let isSwitchEnabled = allowSnapshotsSwitch.isOn
        delegate?.handleSnapshotsSwitchState(isOn: isSwitchEnabled)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        allowSnapshotsSwitch.setOn(AppData.shouldDisplaySnapshots, animated: false)
        allowSnapshotsSwitch.onTintColor = .cmAppDefaultColor
    }

    func configure(with item: SettingsSnapshotsItemInterface) {
        imageView?.image = item.icon
        textLabel?.text = item.title
    }

}
