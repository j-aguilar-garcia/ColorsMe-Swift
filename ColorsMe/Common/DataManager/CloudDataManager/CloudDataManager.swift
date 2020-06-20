//
//  CloudDataManager.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 09.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
import Mapbox

class CloudDataManager : CloudDataManagerProtocol {
    
    public var userAnnotations = [UserAnnotation]()

    public var annotations = [CMAnnotation]() {
        didSet {
            annotations.sort { $0.created! > $1.created! }
        }
    }
    
    private let entitiyName = "UserAnnotation"
    private var context: NSManagedObjectContext!
    let appTransactionAuthorName = "app"
    
    var cloudKitContainerOptions: NSPersistentCloudKitContainerOptions!
    /**
     A persistent container that can load cloud-backed and non-cloud stores.
     */
    var persistentContainer: NSPersistentContainer!
    
    init() {
        log.verbose("init CloudDataManager")
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        setPersistentContainer { (success) in }
        //self.context = persistentContainer.viewContext

        if let tokenData = try? Data(contentsOf: tokenFile) {
            do {
                lastHistoryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
            } catch {
                log.error("###\(#function): Failed to unarchive NSPersistentHistoryToken. Error = \(error)")
            }
        }
        fetchCloudAnnotations()
    }
    
    func fetchCloudAnnotations() {
        userAnnotations = getUserAnnotations()
        annotations = getAnnotations()
    }
    
    func addAnnotation(annotation: CMAnnotation) {
        guard let entity = NSEntityDescription.entity(forEntityName: entitiyName, in: context) else { return  }
        
        let userAnnotation = UserAnnotation(entity: entity, insertInto: context)
        userAnnotation.beObjectId = annotation.objectId
        userAnnotation.city = annotation.city
        userAnnotation.color = annotation.color.rawValue
        userAnnotation.isMyColor = true
        userAnnotation.country = annotation.country
        userAnnotation.countryIsoCode = annotation.isocountrycode
        userAnnotation.created = annotation.created
        userAnnotation.guid = annotation.guid
        userAnnotation.latitude = annotation.latitude
        userAnnotation.longitude = annotation.longitude
        userAnnotation.title = annotation.title
        
        self.context.performAndWait {
            do {
                try self.context.save()
            } catch {
                log.error(error.localizedDescription)
            }
        }
    }
    
    func updateAnnotation(annotation: Annotation) {
        let cloudAnnotation = getAnnotationBy(guid: annotation.guid!)
        cloudAnnotation.beObjectId = annotation.objectId
        self.context.performAndWait {
            do {
                try self.context.save()
            } catch {
                log.error(error.localizedDescription)
            }
        }
    }
    
    func getUserAnnotations() -> [UserAnnotation] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entitiyName)
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        do {
            let result = try context.fetch(request) as! [UserAnnotation]
            userAnnotations = result
            return result
        } catch {
            log.error(error.localizedDescription)
            return userAnnotations
        }
    }
    
    
    func getAnnotations() -> [CMAnnotation] {
        let userAnnotations = getUserAnnotations()
        let localAnnotations = DataManager.shared.localDataManager.getAllLocal()
        var annotations = [CMAnnotation]()
        
        for annotation in userAnnotations {
            guard let cmAnnotation = localAnnotations.first(where: { $0.objectId!.elementsEqual(annotation.beObjectId ?? "nil") }) else {
                continue
            }
            annotations.append(cmAnnotation)
        }
        
        return annotations
    }
    
    
    func deleteAnnotationBy(objectId: String) {
        let annotationToDelete = getAnnotationBy(objectId: objectId)
        context.delete(annotationToDelete)
        self.context.perform {
            do {
                try self.context.save()
            } catch {
                log.error(error.localizedDescription)
            }
        }
    }
    
    func getAnnotationBy(objectId: String) -> UserAnnotation {
        let annotations = getUserAnnotations()
        for annotation in annotations {
            if annotation.beObjectId!.elementsEqual(objectId) {
                return annotation
            }
        }
        return annotations.first!
    }
    
    func getAnnotationBy(guid: String) -> UserAnnotation {
        let annotations = getUserAnnotations()
        for annotation in annotations {
            if annotation.guid!.elementsEqual(guid) {
                return annotation
            }
        }
        return annotations.first!
    }
    
    
    private func setPersistentContainer(completionHandler: @escaping (_ success: Bool) -> Void) {
        var container: NSPersistentContainer?
        container = NSPersistentCloudKitContainer(name: "ColorsMe")
        
        // Enable history tracking and remote notifications
        guard let description = container!.persistentStoreDescriptions.first else {
            completionHandler(false)
            return
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        cloudKitContainerOptions = description.cloudKitContainerOptions
        
        
        // Pin the viewContext to the current generation token and set it to keep itself up to date with local changes.

        
        // Observe Core Data remote change notifications.
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).storeRemoteChange(_:)),
            name: .NSPersistentStoreRemoteChange, object: container)
        
        container!.loadPersistentStores(completionHandler: { (_, error) in
            container!.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container!.viewContext.transactionAuthor = self.appTransactionAuthorName
            container!.viewContext.automaticallyMergesChangesFromParent = true
            do {
                try container!.viewContext.setQueryGenerationFrom(.current)
            } catch {
                completionHandler(false)
                //fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
            }
            guard (error as NSError?) != nil else { return }
            completionHandler(false)
        })
        persistentContainer = container!
        context = container!.viewContext
        completionHandler(true)
        
    }
    
    /**
     Track the last history token processed for a store, and write its value to file.
     The historyQueue reads the token when executing operations, and updates it after processing is complete.
     */
    public var lastHistoryToken: NSPersistentHistoryToken? {
        get {
            do {
                guard let tokenData = UserDefaults.standard.data(forKey: "lastHistoryCloudToken"),
                    let token = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData) else {
                        return nil
                }
                return token
            } catch {
                log.error(error.localizedDescription)
                return nil
            }
        }
        set {
            guard let token = newValue,
                let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else { return }
            
            do {
                try data.write(to: tokenFile)
                let tokenData = try NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: false)
                UserDefaults.standard.set(tokenData, forKey: "lastHistoryCloudToken")
            } catch {
                log.error("###\(#function): Failed to write token data. Error = \(error)")
            }
        }
    }
    
    /**
     The file URL for persisting the persistent history token.
     */
    private lazy var tokenFile: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CoreDataCloudKitColorsMe", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                log.error("###\(#function): Failed to create persistent container URL. Error = \(error)")
            }
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    /**
     An operation queue for handling history processing tasks: watching changes, deduplicating Annotations, and triggering UI updates if needed.
     */
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    /**
     The URL of the thumbnail folder.
     */
    static var attachmentFolder: URL = {
        var url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CoreDataCloudKit", isDirectory: true)
        url = url.appendingPathComponent("attachments", isDirectory: true)
        
        // Create it if it doesn’t exist.
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                log.verbose("###\(#function): Failed to create thumbnail folder URL: \(error)")
            }
        }
        return url
    }()
}


// MARK: - Notifications

extension CloudDataManager {
    
    /**
     Handle remote store change notifications (.NSPersistentStoreRemoteChange).
     */
    @objc
    func storeRemoteChange(_ notification: Notification) {
        log.verbose("###\(#function): Merging changes from the other persistent store coordinator.")
        // Process persistent history to merge changes from other coordinators.
        historyQueue.addOperation {
            self.processPersistentHistory()
        }
    }
    
}


// MARK: - Persistent history processing

extension CloudDataManager {
    
    /**
     Process persistent history, posting any relevant transactions to the current view.
     */
    func processPersistentHistory() {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {
            
            // Fetch history received from outside the app since the last token
            let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
            historyFetchRequest.predicate = NSPredicate(format: "author != %@", appTransactionAuthorName)
            let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
            request.fetchRequest = historyFetchRequest
            
            let result = (try? taskContext.execute(request)) as? NSPersistentHistoryResult
            guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                !transactions.isEmpty
                else { return }
            
            // Post transactions relevant to the current view.
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didFindRelevantTransactions, object: self, userInfo: ["transactions": transactions])
            }
            
            // Deduplicate the new annotationss.
            var newAnnotationObjectIDs = [NSManagedObjectID]()
            let annotationEntityName = entitiyName
            
            for transaction in transactions where transaction.changes != nil {
                for change in transaction.changes!
                    where change.changedObjectID.entity.name == annotationEntityName && change.changeType == .insert {
                        newAnnotationObjectIDs.append(change.changedObjectID)
                }
            }
            if !newAnnotationObjectIDs.isEmpty {
                //deduplicateAndWait(annotationObjectIDs: newAnnotationObjectIDs)
            }
            
            // Update the history token using the last transaction.
            lastHistoryToken = transactions.last!.token
            //saveTokenToUserDefaults(token: lastHistoryToken!)
        }
    }
    
    // MARK: - Save and Load History Token
    func saveTokenToUserDefaults(token: NSPersistentHistoryToken) {
        do {
            let tokenData = try NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: false)
            UserDefaults.standard.set(tokenData, forKey: "lastHistoryCloudToken")
        } catch {
            log.error(error.localizedDescription)
        }
    }
    
    func tokenFromUserDefaults() -> NSPersistentHistoryToken {
        do {
            guard let tokenData = UserDefaults.standard.data(forKey: "lastHistoryCloudToken"),
                let token = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData) else {
                    return NSPersistentHistoryToken()
            }
            return token
        } catch {
            log.error(error.localizedDescription)
            return NSPersistentHistoryToken()
        }
    }
    
}

