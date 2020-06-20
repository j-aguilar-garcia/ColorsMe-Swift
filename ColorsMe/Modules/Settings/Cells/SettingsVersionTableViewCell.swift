//
//  SettingsVersionTableViewCell.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

class SettingsVersionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .none
        detailTextLabel?.textColor = .secondaryLabel
    }

    func configure(with item: SettingsVersionItemInterface) {
        imageView?.image = item.icon
        textLabel?.text = item.title
        detailTextLabel?.text = "\(item.versionNumber) (\(item.buildNumber))"
    }

}
