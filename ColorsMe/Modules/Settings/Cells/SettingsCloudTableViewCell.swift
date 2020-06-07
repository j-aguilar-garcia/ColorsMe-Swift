//
//  SettingsCloudTableViewCell.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

protocol SettingsCloudSyncCellDelegate : class {
    func handleCloudSyncSwitchState(isOn: Bool)
}


class SettingsCloudTableViewCell: UITableViewCell {

    weak var delegate: SettingsCloudSyncCellDelegate?

    @IBOutlet weak var allowCloudSyncSwitch: UISwitch!
    
    @IBAction func onCloudSyncSwitch(_ sender: Any) {
        let isSwitchEnabled = allowCloudSyncSwitch.isOn
        AppData.iCloudDataSyncIsEnabled = isSwitchEnabled
        
        delegate?.handleCloudSyncSwitchState(isOn: isSwitchEnabled)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        allowCloudSyncSwitch.setOn(AppData.iCloudDataSyncIsEnabled, animated: false)
        allowCloudSyncSwitch.onTintColor = .cmAppDefaultColor
        // Initialization code
    }

    func configure(with item: SettingsCloudItemInterface) {
        imageView?.image = item.icon
        textLabel?.text = item.title
    }

}
