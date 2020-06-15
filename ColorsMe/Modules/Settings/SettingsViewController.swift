//
//  SettingsViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {

    // MARK: - Public properties -

    var presenter: SettingsPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        navigationController?.navigationBar.prefersLargeTitles = true
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear(animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections[indexPath.section]
        let item = section.items[indexPath.row]
        switch item {
            
        case .details(let item):
            let cell = tableView.dequeueReusableCell(ofType: SettingsDetailsTableViewCell.self, for: indexPath)
            cell.configure(with: item)
            return cell
            
        case .snapshots(let item):
            let cell = tableView.dequeueReusableCell(ofType: SettingsSnapshotTableViewCell.self, for: indexPath)
            cell.configure(with: item)
            cell.delegate = self
            return cell
        
        case .about(let item):
            let cell = tableView.dequeueReusableCell(ofType: SettingsAboutTableViewCell.self, for: indexPath)
            cell.configure(with: item)
            return cell
            
        case .version(let item):
            let cell = tableView.dequeueReusableCell(ofType: SettingsVersionTableViewCell.self, for: indexPath)
            cell.configure(with: item)
            return cell
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.sections[section].items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.sections[section].header
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return presenter.sections[section].footer
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = presenter.sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch item {
        case .about(let item):
            if let item = item as? SettingsAboutSelectorItem {
                self.presenter.presentTextViewController(with: item)
            }
            if indexPath.row == 2 {
                let share = ShareService.default.shareApp()
                present(share, animated: true, completion: nil)
            } else if indexPath.row == 3 {
                if let url =
                    URL(string: "\(AppConfiguration.default.appStoreUrl!)?action=write-review") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        default:
            break
        }
    }
    
}

// MARK: - Extensions - SettingsViewInterface
extension SettingsViewController: SettingsViewInterface {
    
    func reloadTableView() {
        tableView.reloadData()
    }
}


// MARK: - SettingsSnapshotCellDelegate
extension SettingsViewController : SettingsSnapshotCellDelegate {
    
    func handleSnapshotsSwitchState(isOn: Bool) {
        presenter.handleSnapshotsSwitchState(isOn)
    }
}
