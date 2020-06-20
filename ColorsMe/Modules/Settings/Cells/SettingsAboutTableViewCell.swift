//
//  SettingsAboutTableViewCell.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

class SettingsAboutTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with item: SettingsAboutItemInterface) {
        imageView?.image = item.icon
        title.text = item.title
        accessoryType = item.accessoryType
        if item.isButton {
            textLabel?.textColor = .cmAppDefaultColor
        }
    }

}
