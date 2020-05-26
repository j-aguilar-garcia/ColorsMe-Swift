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


class DataManager : DataManagerInputProtocol {
    
    static let shared = DataManager()
    
    lazy var remoteDataManager : RemoteDataManager = {
        return RemoteDataManager()
    }()
    
    private lazy var localDataManager : LocalDataManager = {
        return LocalDataManager()
    }()
    
    init() {
        remoteDataManager.initBackendless()
    }
    
    
    func dataManager(annotation: Annotation, willSaveWith type: DataManagerType, completion: @escaping (_ success: Bool) -> Void) {
        switch type {
        case .remote:
            remoteDataManager.saveToBackendless(annotation: annotation) { (annotation) in
                
            }
            break
        case .local:
            break
        case .both:
            remoteDataManager.saveToBackendless(annotation: annotation) { (annotation) in
                
            }
            break
        }
    }
    
    
    func dataManager(annotation: Annotation, willDeleteWith type: DataManagerType, completion: @escaping (_ success: Bool) -> Void) {
        switch type {
        case .local:
            localDataManager.deleteLocal(annotation: RealmAnnotation(annotation: annotation))
        default:
            break
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
    
}
