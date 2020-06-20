//
//  DataManagerInputProtocol.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox

enum DataManagerType {
    case remote
    case local
    case both
}

protocol DataManagerInputProtocol {
    
    /// parse and save annotation to local or remote database
    func willSave(annotation: Annotation, with type: DataManagerType, completion: @escaping (_ success: Bool) -> Void)
    
    /// parse and delte annotation to local or remote database
    func willDelete(annotation: Annotation, with type: DataManagerType, completion: @escaping (_ success: Bool) -> Void)
    
    /// fetches data from remote database or calls all local objects
    func dataManager(willRetrieveWith type: DataManagerType, completion: (() -> Void)?) -> [CMAnnotation]
    
    /// filters annotation by PickerDialogFilterOption
    func dataManager(filterBy: PickerDialogFilterOption, with type: DataManagerType, completion: (() -> Void)?) -> [CMAnnotation]
    
    /// Gets all data when the app starts and compares them. Also checks the Internet connection
    func fetchData()
}
