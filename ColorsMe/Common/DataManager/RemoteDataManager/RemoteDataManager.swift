//
//  RemoteDataManager.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Backendless
import CoreLocation

class RemoteDataManager : RemoteDataManagerProtocol {
    
    init() { }
    
    var annotations: [CMAnnotation] = []
    private let dataStore = Backendless.shared.data.of(Annotation.self)
    private var offset = 0
    private var queryBuilder = DataQueryBuilder()
    public var hasDataFetched = false
    
    func initBackendless() {
        Backendless.shared.hostUrl = AppConfiguration.default.backendlessServerUrl
        Backendless.shared.initApp(applicationId: AppConfiguration.default.backendlessAppKey, apiKey: AppConfiguration.default.backendlessApiKey)
    }
    
    func saveToBackendless(annotation: Annotation, completion: @escaping (_ annotation: Annotation) -> Void) {
        let dataStore = Backendless.shared.data.of(Annotation.self)
        dataStore.save(entity: annotation, responseHandler: { [weak self] savedObject in
            if let savedAnnotation = savedObject as? Annotation, self != nil {
                completion(savedAnnotation)
            }
            }, errorHandler: { fault in
                log.error(fault)
                log.error("Error saving remote annotation \(fault.message ?? "")")
        })
    }
    
    func updateToBackendless(annotation: Annotation) {
        let dataStore = Backendless.shared.data.of(Annotation.self)
        dataStore.update(entity: annotation, responseHandler: { updatedObject in
            log.debug("Object updated: \(updatedObject)")
        }, errorHandler: { fault in
            log.error("Error updating remote annotation \(fault.message ?? "")")
        })
    }
    
    func deleteFromBackendless(annotation: Annotation) {
        let dataStore = Backendless.shared.data.of(Annotation.self)
        dataStore.removeById(objectId: annotation.objectId ?? annotation.guid!, responseHandler: { removed in
            log.debug("ColorAnnotation has been deleted \(String(describing: annotation.objectId))")
        }, errorHandler: { fault in
            log.error("Error: \(fault)")
        })
    }
    
    func deleteFromBackendless(by id: String) {
        let dataStore = Backendless.shared.data.of(Annotation.self)
        dataStore.removeById(objectId: id, responseHandler: { removed in
            log.debug("ColorAnnotation has been deleted \(String(describing: removed))")
        }, errorHandler: { fault in
            log.error("Error: \(fault)")
        })
    }
    
    /**
     Downloads all data from the server that has been created since the last check.
     Here the server-side timestamp is used as a global timestamp.
     */
    func retrieveData(localDataManager: LocalDataManager) {
        queryBuilder.setPageSize(pageSize: 100)
        queryBuilder.setOffset(offset: self.offset)
        
        let userAnnotations = DataManager.shared.cloudDataManager.getUserAnnotations()
        
        let dateNow = Date()
        if let timeStamp = AppData.backendlessSyncTimeStamp {
            let dateFormatter = DateFormatter.MMMddyyyyHHmmss
            let dateString = dateFormatter.string(from: timeStamp)
            queryBuilder.setWhereClause(whereClause: String(format: "created > '%@'", dateString))
        }
        
        var remoteAnnotations = [Annotation]()
        let startTime = Date()
        let dataStore = Backendless.shared.data.of(Annotation.self)
        dataStore.find(queryBuilder: self.queryBuilder, responseHandler: { foundObjects in
            dataStore.getObjectCount(responseHandler: { allColors in
                let size = foundObjects.count
                log.debug("CountSize \(allColors)")
                if remoteAnnotations.count == allColors || size == 0 {
                    log.debug("remoteAnnotations.count == allColors \(remoteAnnotations.count == allColors)")
                    log.debug("Retrieved data in (ms) - \(Int(Date().timeIntervalSince(startTime) * 1000)) in secs \(Int(Date().timeIntervalSince(startTime)))")
                    self.offset = 0
                    self.checkForDeletedData(localDataManager: localDataManager, date: dateNow)
                    return
                } else {
                    guard let annotations = foundObjects as? [Annotation] else { return }
                    for annotation in annotations {
                        remoteAnnotations.append(annotation)
                        
                        let isMyColor = userAnnotations.contains(where: { ($0.beObjectId!.elementsEqual(annotation.objectId!)) } )
                        log.debug(isMyColor)
                        let realmAnnotation = RealmAnnotation(annotation: annotation, isMyColor: isMyColor)
                        
                        let localAnnotations = localDataManager.getAllLocal()
                        if localAnnotations.contains(where: { $0.objectId!.elementsEqual(annotation.objectId!)} ) {
                            
                            /*let rlmAnnotation = localDataManager.getObjectBy(primaryKey: annotation.objectId!)
                            rlmAnnotation?.isMyColor = true*/
                            localDataManager.updateLocal(annotation: realmAnnotation)
                        } else {
                            localDataManager.saveLocal(annotation: realmAnnotation)
                        }
                        self.annotations.append(CMAnnotation(annotation: realmAnnotation))
                    }
                    self.offset += size
                    self.queryBuilder.setOffset(offset: self.offset)
                }
                if self.queryBuilder.getOffset() < allColors {
                    log.debug("queryBuilder.getOffset() = \(self.queryBuilder.getOffset())")
                    self.retrieveData(localDataManager: localDataManager)
                } else {
                    AppData.backendlessSyncTimeStamp = dateNow
                    log.debug("Retrieved data in (ms) - \(Int(Date().timeIntervalSince(startTime) * 1000)) in secs \(Int(Date().timeIntervalSince(startTime)))")
                }
            }, errorHandler: { fault in
                log.error("Fault = \(fault)")
            })
        }, errorHandler: { fault in
            log.error("Fault \(fault)")
            log.error("Error get all Annotations: \(fault.message ?? "Error while retriving all Annotations)")")
        })
    }
    
    
    /**
     Determines all delted Annotations while the app was closed.
     All annotations that no longer exist on the server are deleted locally.
    */
    private func checkForDeletedData(localDataManager: LocalDataManager, date: Date) {
        let localAnnotations = localDataManager.getAllLocal()
        var remoteAnnotations = [Annotation]()
        queryBuilder.setPageSize(pageSize: 100)
        queryBuilder.setOffset(offset: self.offset)
        //queryBuilder.setGroupBy(groupBy: ["objectId"])
        
        let dateFormatter = DateFormatter.MMMddyyyyHHmmss
        let dateString = dateFormatter.string(from: date)
        //queryBuilder.setWhereClause(whereClause: String(format: "created < '%@'", dateString))
        
        
        let dataStore = Backendless.shared.data.of(Annotation.self)
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { (foundObjects) in
            dataStore.getObjectCount(responseHandler: { allColors in
                
                let size = foundObjects.count
                if size == 0 || localAnnotations.count == foundObjects.count {
                    log.debug("size delete = \(remoteAnnotations.count)")

                    for annotation in localAnnotations {
                        log.debug("local ID = \(annotation.objectId)")
                        if !remoteAnnotations.contains(where: { $0.objectId == annotation.objectId }) {
                            log.debug("DONT DELETE ")
                            continue
                        }
                        DispatchQueue.main.async {
                            log.debug("DELETE")
                            //localDataManager.deleteLocal(by: annotation.objectId!)
                        }
                    }
                    self.hasDataFetched = true
                    return
                } else {
                    guard let annotations = foundObjects as? [Annotation] else { return }
                    for annotation in annotations {
                        remoteAnnotations.append(annotation)
                    }
                    
                    self.offset += size
                    self.queryBuilder.setOffset(offset: self.offset)
                }
                if self.queryBuilder.getOffset() < allColors {
                    log.debug("queryBuilder.getOffset() = \(self.queryBuilder.getOffset())")
                    self.checkForDeletedData(localDataManager: localDataManager, date: date)
                }
            }, errorHandler: { fault in
                log.error("Fault = \(fault)")
            })
        }, errorHandler: { fault in
            log.error("Fault \(fault)")
            log.error("Error get all Annotations: \(fault.message ?? "Error while retrieving all to delete)")")
        })
    }
    
    
    
}
