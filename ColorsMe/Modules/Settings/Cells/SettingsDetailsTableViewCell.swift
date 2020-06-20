//
//  SettingsDetailsTableViewCell.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

class SettingsDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .none
    }

    func configure(with item: SettingsDetailsItemInterface) {
        imageView?.image = item.icon
        titleLabel.text = item.title
        subtitleLabel.text = item.entries
        
        imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView?.layer.masksToBounds = true
        imageView?.layer.cornerRadius = (imageView?.frame.width)! / 3

        let itemSize = CGSize.init(width: 35, height: 35)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        imageView?.image!.draw(in: imageRect)
        imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
    }

}
