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
import EmptyDataSet_Swift

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
        presenter.didSelectAddAction(color: .Green)
    }
    
    @IBAction func onYellowButton(_ sender: Any) {
        presenter.didSelectAddAction(color: .Yellow)
    }
    
    @IBAction func onRedButton(_ sender: Any) {
        presenter.didSelectAddAction(color: .Red)
    }
    
    @IBOutlet weak var buttonViewBottomToTableViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewBottomToTabBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewContainerLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewContainerTrailing: NSLayoutConstraint!
    
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        hintColorLabel.text = "Green means Happy | Red means sick"
        questionView.dropShadow()
        
        let fetchRequest : NSFetchRequest<UserAnnotation> = UserAnnotation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tableDataSource = FRCTableViewDataSource(fetchRequest: fetchRequest, context: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, delegate: self, tableView: tableView)
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDataSource
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

        self.navigationController?.navigationBar.isHidden = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            tableViewContainerLeading.priority = .defaultLow
            tableViewContainerTrailing.priority = .defaultLow
            tableViewContainerWidthConstraint.priority = .defaultHigh
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            tableViewContainerLeading.priority = .defaultHigh
            tableViewContainerTrailing.priority = .defaultHigh
            tableViewContainerWidthConstraint.priority = .defaultLow
            
        }
        
        try! tableDataSource.performFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        try? tableDataSource.performFetch()

        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        updateConstraints()
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
        //try? tableDataSource.performFetch()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    
    private func updateConstraints() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.tableView.contentInset = UIEdgeInsets(top: -24, left: 0, bottom: 0, right: 0)
            tableViewContainerWidthConstraint.constant = UIScreen.main.bounds.width
        }
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
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let guid = tableDataSource.object(at: indexPath).guid!
        let activityVC = ShareService.default.share(guid: guid, view: self.view)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    private func onShowSwipe(_ indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.tabBarController?.selectedIndex = 0
        let annotation = tableDataSource.object(at: indexPath)
        guard let colorAnnotation = DataManager.shared.localDataManager.filterLocalBy(objectId: annotation.beObjectId!) else { return }
        presenter.zoomToAnnotation(annotation: colorAnnotation)
    }
    
    
    private func onDeleteSwipe(_ indexPath: IndexPath) {
        let annotationToDelete = tableDataSource.object(at: indexPath)
        AnnotationService.default.deleteAnnotation(id: annotationToDelete.beObjectId!, objectId: annotationToDelete.objectID)
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
    
    
    func frcTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EmotionalDiaryTableViewCell else {
            return
        }
        cell.showSwipe(.rightToLeft, animated: true)
    }
}

extension EmotionalDiaryViewController : EmptyDataSetDelegate , EmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyColorsDataSet")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title = "There are no Colors in your Emotional Diary."
        let font = [ NSAttributedString.Key.font: UIFont.light(ofSize: 16) ]
        let attributedString = NSAttributedString(string: title, attributes: font)

        return attributedString
    }
}
