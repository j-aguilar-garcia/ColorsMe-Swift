//
//  RemoteDataManager.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Backendless
import CloudKit
import Reachability

class DataManager : DataManagerInputProtocol {
    
    static let shared = DataManager()
    
    lazy var remoteDataManager : RemoteDataManager = {
        return RemoteDataManager()
    }()
    
    lazy var localDataManager : LocalDataManager = {
        return LocalDataManager()
    }()
    
    init() {
        remoteDataManager.initBackendless()
    }
    
    
    func fetchData() {
        if !remoteDataManager.hasDataFetched {
            let reachability = try! Reachability()
            if reachability.connection != .unavailable {
                _ = dataManager(willRetrieveWith: .remote)
            } else {
                NotificationCenter.default.post(name: .networkReachability, object: nil)
            }
        }
    }
    
    
    func willSave(annotation: Annotation, with type: DataManagerType, completion: @escaping (_ success: Bool) -> Void) {
        switch type {
        case .remote:
            remoteDataManager.saveToBackendless(annotation: annotation) { (annotation) in
                //completion(success)
            }
            
        case .local:
            localDataManager.saveLocal(annotation: RealmAnnotation(annotation: annotation))
            
        case .both:
            remoteDataManager.saveToBackendless(annotation: annotation) { (annotation) in
                self.localDataManager.saveLocal(annotation: RealmAnnotation(annotation: annotation))
            }
        }
    }
    
    
    func willDelete(annotation: Annotation, with type: DataManagerType, completion: @escaping (_ success: Bool) -> Void) {
        switch type {
            
        case .remote:
            remoteDataManager.deleteFromBackendless(annotation: annotation)
            
        case .local:
            localDataManager.deleteLocal(annotation: RealmAnnotation(annotation: annotation))
            
        case .both:
            remoteDataManager.deleteFromBackendless(annotation: annotation)
            localDataManager.deleteLocal(annotation: RealmAnnotation(annotation: annotation))
        }
    }
    
    
    func dataManager(willRetrieveWith type: DataManagerType, completion: (() -> Void)? = nil) -> [CMAnnotation] {
        switch type {
            
        case .local:
            return localDataManager.getAllLocal()
        
        case .remote:
            remoteDataManager.retrieveData(localDataManager: localDataManager)
            
        default:
            return localDataManager.getAllLocal()
        }
        
        return [CMAnnotation]()
    }
    
    
    func dataManager(filterBy: PickerDialogFilterOption, with type: DataManagerType, completion: (() -> Void)?) -> [CMAnnotation] {
        switch type {
        case .local:
            return localDataManager.filterLocal(by: filterBy)
        default:
            break
        }
        return [CMAnnotation]()
    }
    
    
    func dataManager(id: String, willDeltewith type: DataManagerType) {
        switch type {
        case .local:
            localDataManager.deleteLocal(by: id)

        case .remote:
            remoteDataManager.deleteFromBackendless(by: id)
            
        case .both:
            remoteDataManager.deleteFromBackendless(by: id)
            localDataManager.deleteLocal(by: id)
        }
    }
    
    
}
