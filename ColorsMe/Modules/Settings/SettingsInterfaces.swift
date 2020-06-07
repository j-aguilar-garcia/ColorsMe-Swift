//
//  SettingsInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

enum SettingsNavigationOption {
    case textview(SettingsAboutSelectorItem)
}

protocol SettingsWireframeInterface: WireframeInterface {
    func navigate(to option: SettingsNavigationOption)
}

protocol SettingsViewInterface: ViewInterface {
    func reloadTableView()
}

protocol SettingsPresenterInterface: PresenterInterface {
    var sections: [Section<SettingsItem>] { get }
    func handleCloudSyncSwitchState(_ isOn: Bool)
    func handleSnapshotsSwitchState(_ isOn: Bool)
    func presentTextViewController(with: SettingsAboutSelectorItem)
}

enum SettingsItem {
    case details(SettingsDetailsItemInterface)
    case synchronisation(SettingsCloudItemInterface)
    case snapshots(SettingsSnapshotsItemInterface)
    case about(SettingsAboutItemInterface)
    case version(SettingsVersionItemInterface)
}

protocol SettingsDetailsItemInterface {
    var icon : UIImage { get }
    var title : String { get }
    var entries : String { get }
}

protocol SettingsCloudItemInterface {
    var icon : UIImage { get }
    var title : String { get }
    var isEnabled : Bool { get }
}

protocol SettingsSnapshotsItemInterface {
    var icon : UIImage { get }
    var title : String { get }
    var isEnabled : Bool { get }
}

protocol SettingsAboutItemInterface {
    var icon : UIImage { get }
    var title : String { get }
    var isButton : Bool { get }
    var accessoryType : UITableViewCell.AccessoryType { get }
}

protocol SettingsVersionItemInterface {
    var icon : UIImage { get }
    var title : String { get }
    var versionNumber : String { get }
    var buildNumber : String { get }
}
