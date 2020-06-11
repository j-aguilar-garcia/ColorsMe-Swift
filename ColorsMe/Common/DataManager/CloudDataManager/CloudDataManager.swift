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
    
    private let entitiyName = "UserAnnotation"
    private let context: NSManagedObjectContext!
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
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
    
    
    func getUserAnnotations() -> [UserAnnotation] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entitiyName)
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        var fetchedAnnotations = [UserAnnotation]()
        do {
            let result = try context.fetch(request) as! [UserAnnotation]
            fetchedAnnotations = result
            return result
        } catch {
            log.error(error.localizedDescription)
            return fetchedAnnotations
        }
    }
    
    
    func getAnnotations() -> [CMAnnotation] {
        let userAnnotations = getUserAnnotations()
        let localAnnotations = DataManager.shared.localDataManager.getAllLocal()
        var annotations = [CMAnnotation]()
        
        for annotation in userAnnotations {
            guard let cmAnnotation = localAnnotations.first(where: { $0.objectId!.elementsEqual(annotation.beObjectId!) }) else {
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
    
}
