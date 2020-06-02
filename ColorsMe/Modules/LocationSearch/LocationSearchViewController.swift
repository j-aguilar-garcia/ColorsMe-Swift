//
//  LocationSearchViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 01.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import MapboxGeocoder
import Mapbox

final class LocationSearchViewController : UITableViewController {

    // MARK: - Public properties -

    var presenter: LocationSearchPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.debug("didSelectRow - \(indexPath.row)")
        presenter.didSelectRowAt(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        let selectedItem = presenter.searchResults[indexPath.row]
        
        cell.textLabel?.text = selectedItem.qualifiedName!
        
        return cell
    }
    

}

// MARK: - Extensions -

extension LocationSearchViewController : LocationSearchViewInterface {
    
    func reloadData() {
        tableView.reloadData()
    }
    
}

extension LocationSearchViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.count > 1 {
            presenter.search(text: searchController.searchBar.text!)
        }
        
    }
    
    
    
}
