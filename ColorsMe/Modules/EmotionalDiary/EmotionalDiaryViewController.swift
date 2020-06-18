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
    private let imageCache = ImageCache()

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

        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        tableViewContainerLeading.priority = .defaultHigh
        tableViewContainerTrailing.priority = .defaultHigh
        tableViewContainerWidthConstraint.priority = .defaultLow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        presenter.syncAnnotations()
        updateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear(animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        updateConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateConstraints()
    }
}


// MARK: - UITableView

extension EmotionalDiaryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.userAnnotations.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(ofType: EmotionalDiaryTableViewCell.self, for: indexPath)
        cell.configure(annotation: item, imageCache: imageCache)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 95
        }
        return 70
    }
    
}

// MARK: - Extensions -

extension EmotionalDiaryViewController: EmotionalDiaryViewInterface {
    
    func reloadTableView() {
        tableView.reloadData()
        tableView.reloadEmptyDataSet()
    }
    
    
    private func updateConstraints() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.tableView.contentInset = UIEdgeInsets(top: -24, left: 0, bottom: 0, right: 0)
            //tableViewContainerWidthConstraint.constant = UIScreen.main.bounds.width
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
                onShowSwipe(indexPath)
            } else if index == 1 {
                onShareSwipe(indexPath)
            }
        }
        return true
    }
    
    
    private func onShareSwipe(_ indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let guid = presenter.object(at: indexPath).guid!
        let activityVC = ShareService.default.share(guid: guid, view: self.view)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    private func onShowSwipe(_ indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.tabBarController?.selectedIndex = 0
        let annotation = presenter.object(at: indexPath)
        presenter.zoomToAnnotation(annotation: annotation)
    }
    
    
    private func onDeleteSwipe(_ indexPath: IndexPath) {
        let annotationToDelete = presenter.object(at: indexPath)        
        tableView.beginUpdates()
        AnnotationService.default.deleteAnnotation(annotationToDelete, completion: {
            self.presenter.deleteUserAnnotation(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        tableView.endUpdates()
        ImageCache().clear(key: annotationToDelete.guid!)

        if AppData.iCloudDataSyncIsEnabled {
            AppData.lastCloudSync = Date()
            AppData.iCloudHasSynced = true
        }
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
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
