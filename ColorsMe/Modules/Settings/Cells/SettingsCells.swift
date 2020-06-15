//
//  SettingsCells.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

class SettingsDetailsItem : SettingsDetailsItemInterface {
    var icon: UIImage
    var title: String
    var entries: String
    
    init(icon: UIImage, title: String, entries: String) {
        self.icon = icon
        self.title = title
        self.entries = entries
    }
}


class SettingsCloudItem : SettingsCloudItemInterface {
    var icon: UIImage
    var title: String
    var isEnabled: Bool
    
    init(icon: UIImage, title: String, isEnabled: Bool) {
        self.icon = icon
        self.title = title
        self.isEnabled = isEnabled
    }
}


class SettingsSnapshotItem : SettingsSnapshotsItemInterface {
    var icon: UIImage
    var title: String
    var isEnabled: Bool
    
    init(icon: UIImage, title: String, isEnabled: Bool) {
        self.icon = icon
        self.title = title
        self.isEnabled = isEnabled
    }
}


class SettingsAboutItem : SettingsAboutItemInterface {
    var icon: UIImage
    var title: String
    var isButton: Bool
    var accessoryType: UITableViewCell.AccessoryType
    
    init(icon: UIImage, title: String, isButton: Bool, accessoryType: UITableViewCell.AccessoryType) {
        self.icon = icon
        self.title = title
        self.isButton = isButton
        self.accessoryType = accessoryType
    }
}


class SettingsAboutSelectorItem : SettingsAboutItem {
    var key: String
    var navigationTitle: String

    init(icon: UIImage, title: String, isButton: Bool, accessoryType: UITableViewCell.AccessoryType, key: String, navigationTitle: String) {
        self.key = key
        self.navigationTitle = navigationTitle
        super.init(icon: icon, title: title, isButton: isButton, accessoryType: accessoryType)
    }
}


class SettingsVersionItem : SettingsVersionItemInterface {
    var icon: UIImage
    var title: String
    var versionNumber: String
    var buildNumber: String
    
    init(icon: UIImage, title: String, versionNumber: String, buildNumber: String) {
        self.icon = icon
        self.title = title
        self.versionNumber = versionNumber
        self.buildNumber = buildNumber
    }
}
