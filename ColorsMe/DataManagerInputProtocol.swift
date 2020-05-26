//
//  DataManagerInputProtocol.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation


@objc enum DataManagerType : Int {
    case remote
    case local
    case both
}

@objc protocol DataManagerInputProtocol {
    
    @objc optional func dataManager(annotation: Annotation, willSaveWith type: DataManagerType, completion: @escaping (_ success: Bool) -> Void)
    @objc optional func dataManager(annotation: Annotation, willDeleteWith type: DataManagerType, completion: @escaping (_ success: Bool) -> Void)
    @objc optional func dataManager(willRetrieveWith type: DataManagerType, completion: (() -> Void)?) -> [CMAnnotation]
    
}
