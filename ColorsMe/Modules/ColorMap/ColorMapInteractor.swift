//
//  ColorMapInteractor.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox
import Backendless
import Reachability
import CoreData

final class ColorMapInteractor {
    var presenter: ColorMapPresenterInterface!
}

// MARK: - Extensions -

extension ColorMapInteractor: ColorMapInteractorInterface {
    
    func checkForAnnotationInCoreData(annotation: CMAnnotation) -> Bool {
        let fetchRequest : NSFetchRequest<UserAnnotation> = UserAnnotation.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let annotations = try? context.fetch(fetchRequest)
        for anno in annotations! {
            if anno.beObjectId == annotation.objectId {
                return true
            }
        }
        return false
    }
    
    
    func shouldUpdateScale(mapView: MGLMapView, oldValue: Float) {
        var result: Float!
        var duration: Double!
        let oldSliderValue = oldValue
        guard let visibleAnnotations = mapView.visibleAnnotations as? [CMAnnotation] else { return }

        if visibleAnnotations.count == 0 {
            result = 0.5
        } else {
            let countRedColors = visibleAnnotations.filter { $0.color! == EmotionalColor.Red }.count
            let countYellowColors = visibleAnnotations.filter { $0.color! == EmotionalColor.Yellow }.count
            let countGreenColors = visibleAnnotations.filter { $0.color! == EmotionalColor.Green }.count
            let yellowColorsValue = Float(countYellowColors) * 0.5
            result = (yellowColorsValue + Float(countGreenColors)) / (Float(countRedColors) + Float(countYellowColors) + Float(countGreenColors))
        }
        
        let isOldValueBigger = oldSliderValue > result
        let differenceBetweenValues = isOldValueBigger ? oldSliderValue - result : result - oldSliderValue

        duration = differenceBetweenValues <= 0.33 ? 1 : differenceBetweenValues > 0.33 && differenceBetweenValues <= 0.66 ? 0.8 : 0.4
        presenter.willUpdateScale(value: result, duration: duration)
    }
    
    
    func addSubscriptionsObserver() {
        let eventHandler = Backendless.shared.data.of(Annotation.self).rt
        
        _ = eventHandler?.addCreateListener(responseHandler: { createdObject in
            guard let annotation = createdObject as? Annotation else { return }
            
            let realmAnnotation = RealmAnnotation(annotation: annotation)
            DataManager.shared.localDataManager.saveLocal(annotation: realmAnnotation)
            
            let cmAnnotation = CMAnnotation(annotation: annotation)
            self.presenter.willAddAnnotation(cmAnnotation)
            
            log.verbose("annotation has been created via createListener: \(annotation)")
        }, errorHandler: { fault in
            log.error("Error: \(fault.message ?? "")")
        })
        
        
        _ = eventHandler?.addDeleteListener(responseHandler: { deletedObject in
            guard let annotation = deletedObject as? Annotation else { return }
            
            guard let cmAnnotation = DataManager.shared.localDataManager.getAnnotationBy(primaryKey: annotation.objectId!) else { return }
            self.presenter.willRemoveAnnotation(cmAnnotation)
            
            DataManager.shared.localDataManager.deleteLocal(by: annotation.objectId!)
            
            log.verbose("annotation has been deleted via deleteListener: \(cmAnnotation)")
        }, errorHandler: { fault in
            log.error("Error: \(fault.message ?? "")")
        })
    }
    
    
    func addNetworkReachabilityObserver() {
        NotificationCenter.default.addObserver(forName: .networkReachability, object: nil, queue: nil) { (notification) in
            let reachability = try! Reachability()
            if reachability.connection == .unavailable {
                self.presenter.reachabilityChanged(false)
            }
            if reachability.connection != .unavailable {
                self.presenter.reachabilityChanged(true)
            }
        }
    }
    
}
