//
//  FRCTableDataSource.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 03.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import CoreData
import UIKit

protocol FRCTableViewDelegate: class {
    func frcTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func frcTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

class FRCTableViewDataSource<FetchRequestResult: NSFetchRequestResult>: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    let frc: NSFetchedResultsController<FetchRequestResult>
    weak var tableView: UITableView?
    weak var delegate: FRCTableViewDelegate?
    
    init(fetchRequest: NSFetchRequest<FetchRequestResult>, context: NSManagedObjectContext, sectionNameKeyPath: String?) {
        frc = NSFetchedResultsController<FetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        
        super.init()
        
        frc.delegate = self
    }
    
    convenience init(fetchRequest: NSFetchRequest<FetchRequestResult>, context: NSManagedObjectContext, sectionNameKeyPath: String?, delegate: FRCTableViewDelegate, tableView: UITableView) {
        self.init(fetchRequest: fetchRequest, context: context, sectionNameKeyPath: sectionNameKeyPath)
        
        self.delegate = delegate
        self.tableView = tableView
    }
    
    func performFetch() throws {
        try frc.performFetch()
    }
    
    func object(at indexPath: IndexPath) -> FetchRequestResult {
        return frc.object(at: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frc.sections else { return 0 }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let delegate = delegate {
            return delegate.frcTableView(tableView, cellForRowAt: indexPath)
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.frcTableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let sectionIndexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert: tableView?.insertSections(sectionIndexSet, with: .automatic)
        case .delete: tableView?.deleteSections(sectionIndexSet, with: .automatic)
        case .update: tableView?.reloadSections(sectionIndexSet, with: .automatic)
        case .move: break
        @unknown default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView?.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {
                log.error("indexpath is not indexpath - can not delete")
                break
            }
            tableView?.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView?.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return nil }
    
    
}


