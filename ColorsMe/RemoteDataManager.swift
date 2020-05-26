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

private let APPLICATION_ID = "66EA18F7-900C-B8AC-FF71-DE3840F6F300"
private let API_KEY = "6E3F3D27-BB5E-6B7F-FFD2-1208DAC94600"
private let SERVER_URL = "https://api.backendless.com"

class RemoteDataManager : RemoteDataManagerInputProtocol {
        
    init() { }
    
    var annotations: [CMAnnotation] = []
    private let dataStore = Backendless.shared.data.of(Annotation.self)
    private var offset = 0
    private var queryBuilder = DataQueryBuilder()
    private var backendlessDataRetrieved = false

    func initBackendless() {
        Backendless.shared.hostUrl = SERVER_URL
        Backendless.shared.initApp(applicationId: APPLICATION_ID, apiKey: API_KEY)
    }
    
    func saveToBackendless(annotation: Annotation, completion: @escaping (_ annotation: Annotation) -> Void) {
        let dataStore = Backendless.shared.data.of(Annotation.self)
        dataStore.save(entity: annotation, responseHandler: { [weak self] savedObject in
            if let savedAnnotation = savedObject as? Annotation, self != nil {
                completion(savedAnnotation)
            }
        }, errorHandler: { fault in
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
    
    
    func retrieveData(localDataManager: LocalDataManager) {
        queryBuilder.setPageSize(pageSize: 100)
        queryBuilder.setOffset(offset: self.offset)
        
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
                if remoteAnnotations.count == allColors {
                    log.debug("remoteAnnotations.count == allColors \(remoteAnnotations.count == allColors)")
                    log.debug("Retrieved data in (ms) - \(Int(Date().timeIntervalSince(startTime) * 1000)) in secs \(Int(Date().timeIntervalSince(startTime)))")
                    return
                }
                if size == 0 {
                    self.backendlessDataRetrieved = true
                    log.debug("Retrieved data in (ms) - \(Int(Date().timeIntervalSince(startTime) * 1000)) in secs \(Int(Date().timeIntervalSince(startTime)))")
                    return
                } else {
                    for object in foundObjects {
                        if let annotation = object as? Annotation {
                            remoteAnnotations.append(annotation)
                            localDataManager.saveLocal(annotation: RealmAnnotation(annotation: annotation))
                            self.annotations.append(CMAnnotation(annotation: annotation))
                        }
                    }
                    self.offset += size
                    self.queryBuilder.setOffset(offset: self.offset)
                }
                if self.queryBuilder.getOffset() < allColors {
                    log.debug("\(#function) queryBuilder.getOffset() \(self.queryBuilder.getOffset())")
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
    

    
    
    
    
}
