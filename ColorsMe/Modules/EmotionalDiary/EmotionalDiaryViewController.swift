//
//  EmotionalDiaryViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import CoreData
import CloudKit

final class EmotionalDiaryViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: EmotionalDiaryPresenterInterface!

    var tableDataSource: FRCTableViewDataSource<UserAnnotation>!
    // MARK: - Outlets
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var hintColorLabel: UILabel!
    
    @IBAction func onGreenButton(_ sender: Any) {
        //presenter.addAnnotation(color: .Green)
    }
    
    @IBAction func onYellowButton(_ sender: Any) {
        //presenter.addAnnotation(color: .Yellow)
    }
    
    @IBAction func onRedButton(_ sender: Any) {
        //presenter.
    }
    
    @IBOutlet weak var buttonViewBottomToTableViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewBottomToTabBarTopConstraint: NSLayoutConstraint!
    
    
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        hintColorLabel.text = "Green means Happy | Red means sick"
        questionView.dropShadow()
        
        let fetchRequest : NSFetchRequest<UserAnnotation> = UserAnnotation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tableDataSource = FRCTableViewDataSource(fetchRequest: fetchRequest, context: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, delegate: self, tableView: tableView)
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDataSource
        try! tableDataSource.performFetch()

        self.navigationController?.navigationBar.isHidden = true
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.tableView.contentInset = UIEdgeInsets(top: -24, left: 0, bottom: 0, right: 0)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.tableView.setCorner()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateConstraints()
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
    }
    
    override func viewWillLayoutSubviews() {
        updateConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateConstraints()
    }

    

}

// MARK: - Extensions -

extension EmotionalDiaryViewController: EmotionalDiaryViewInterface {
    
    func reloadTableView() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    
    private func updateConstraints() {
        if UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom == .pad {
            if buttonViewBottomToTableViewTopConstraint != nil && tableViewBottomToTabBarTopConstraint != nil {
                buttonViewBottomToTableViewTopConstraint.constant = 16
                tableViewBottomToTabBarTopConstraint.constant = 32
            }
        } else if UIDevice.current.orientation.isPortrait && UIDevice.current.userInterfaceIdiom == .pad {
            if buttonViewBottomToTableViewTopConstraint != nil && tableViewBottomToTabBarTopConstraint != nil {
                buttonViewBottomToTableViewTopConstraint.constant = 80
                tableViewBottomToTabBarTopConstraint.constant = 120
            }
        }
    }
    
}

extension EmotionalDiaryViewController : MGSwipeTableCellDelegate {
    
    func swipeTableCell(_ cell: MGSwipeTableCell, shouldHideSwipeOnTap point: CGPoint) -> Bool {
        return true
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        guard let indexPath = tableView.indexPath(for: cell) else { return false }
        if direction == .leftToRight {
            onDeleteSwipe(indexPath)
        } else {
            if index == 0 {
                onShareSwipe(indexPath)
            } else if index == 1 {
                onShowSwipe(indexPath)
            }
        }
        return true
    }
    
    
    private func onShareSwipe(_ indexPath: IndexPath) {
        var components = URLComponents()
            components.scheme = "https"
            components.host = "colorsme.bit-design.org"
            components.path = "/"
            components.queryItems = [
                URLQueryItem(name: "id", value: "\(tableDataSource.object(at: indexPath).guid!)")
            ]
            let urlToShare = components.url?.absoluteString
            let objectsToShare = [urlToShare!] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
        activityVC.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll
        ]
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popover.sourceView = self.view
            popover.permittedArrowDirections = .any
        }
            
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    private func onShowSwipe(_ indexPath: IndexPath) {
        self.tabBarController?.selectedIndex = 0
        let annotation = tableDataSource.object(at: indexPath)
        #warning("zoom to annotation")
    }
    
    
    private func onDeleteSwipe(_ indexPath: IndexPath) {
        let annotationToDelete = tableDataSource.object(at: indexPath)
        let info = ["guid" : annotationToDelete.guid!]
        tableView.beginUpdates()
        #warning("Delete Annotation")
        //AnnotationManager.shared.annotations.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        ImageCache().clear(key: annotationToDelete.guid!)
        
        if AppData.iCloudDataSyncIsEnabled {
            AppData.lastCloudSync = Date()
            AppData.iCloudHasSynced = true
        }
    }
}


extension EmotionalDiaryViewController : FRCTableViewDelegate {
    
    func frcTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableDataSource.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(ofType: EmotionalDiaryTableViewCell.self, for: indexPath)
        cell.configure(annotation: item)
        cell.delegate = self
        cell.configureSwipes()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EmotionalDiaryTableViewCell else {
            return
        }
        cell.showSwipe(.rightToLeft, animated: true)
    }
    
}
