//
//  SettingsPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

final class SettingsPresenter {
    
    // MARK: - Private properties -
    
    private unowned let view: SettingsViewInterface
    private let wireframe: SettingsWireframeInterface
    
    var sections : [Section<SettingsItem>] = []
    
    // MARK: - Lifecycle -
    
    init(view: SettingsViewInterface, wireframe: SettingsWireframeInterface) {
        self.view = view
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension SettingsPresenter: SettingsPresenterInterface {
    
    private func cloudSectionFooterTitle() -> String {
        if !AppData.iCloudDataSyncIsEnabled {
            return "iCloud data synchronization is disabled."
        }
        if AppData.iCloudHasSynced {
            let lastSyncDate = AppData.lastCloudSync
            let calendar = Calendar.current
            let timeFormatter = DateFormatter.HHmmss
            
            if calendar.isDateInToday(lastSyncDate) {
                return "Last sync: Today at \(timeFormatter.string(from: lastSyncDate))"
            } else if calendar.isDateInYesterday(lastSyncDate) {
                return "Last sync: Yesterday at \(timeFormatter.string(from: lastSyncDate))"
            } else {
                let dateTimeFormatter = DateFormatter.ddMMyyyy
                return "Last sync: \(dateTimeFormatter.string(from: lastSyncDate))"
            }
        }
        return "No data has been synchronized yet."
    }
    
    private var infoSection: Section<SettingsItem> {
        return Section(
            items: [SettingsItem.details(
                SettingsDetailsItem(icon: UIImage(named: "Logo")!, title: "My Emotional Diary", entries: "Entries: tbd")
                )]
        )
    }
    
    private var cloudSection: Section<SettingsItem> {
        return Section(
            items: [
                SettingsItem.synchronisation(
                    SettingsCloudItem(icon: UIImage(systemName: "cloud")!, title: "iCloud", isEnabled: AppData.iCloudDataSyncIsEnabled)
                )],
            header: "Synchronisation",
            footer: cloudSectionFooterTitle()
        )
    }
    
    private var snapshotsSection: Section<SettingsItem> {
        return Section(
            items: [
                SettingsItem.snapshots(
                    SettingsSnapshotItem(icon: UIImage(systemName: "photo")!, title: "ColorSnapshots", isEnabled: AppData.shouldDisplaySnapshots)
                )],
            footer: "If enabled, your colors are displayed with a snapshot"
        )
    }
    
    private var aboutSection: Section<SettingsItem> {
        return Section(
            items: [
                SettingsItem.about(
                    SettingsAboutSelectorItem(icon: UIImage(systemName: "info.circle")!, title: "About", isButton: false, accessoryType: .disclosureIndicator, remoteConfigKey: "attributed_text_impressum", navigationTitle: "Imprint")),
                SettingsItem.about(
                    SettingsAboutSelectorItem(icon: UIImage(systemName: "hand.raised")!, title: "Privacy Policy", isButton: false, accessoryType: .disclosureIndicator, remoteConfigKey: "attributed_text_privacy_policy", navigationTitle: "Privacy Policy")),
                SettingsItem.about(
                    SettingsAboutItem(icon: UIImage(systemName: "square.and.arrow.up")!, title: "Share", isButton: true, accessoryType: .none)),
                SettingsItem.about(
                    SettingsAboutItem(icon: UIImage(systemName: "star")!, title: "Rate ColorsMe", isButton: true, accessoryType: .none)
                )],
            footer: "We were pleased about a honest review in the AppStore."
        )
    }
    
    private var versionSection: Section<SettingsItem> {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        return Section(
            items: [
                SettingsItem.version(
                    SettingsVersionItem(icon: UIImage(systemName: "hammer")!, title: "Version", versionNumber: version, buildNumber: build)
                )]
        )
    }
    
    func viewDidLoad() {
        sections = [
            infoSection,
            cloudSection,
            snapshotsSection,
            aboutSection,
            versionSection
        ]
        view.reloadTableView()
    }
    
    func handleCloudSyncSwitchState(_ isOn: Bool) {
        AppData.iCloudDataSyncIsEnabled = isOn
        #warning("Handle CloudCore - enable")
    }
    
    func handleSnapshotsSwitchState(_ isOn: Bool) {
        AppData.shouldDisplaySnapshots = isOn
    }
    
    func presentTextViewController(with item: SettingsAboutSelectorItem) {
        wireframe.navigate(to: .textview(item))
    }
}
