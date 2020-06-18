//
//  EmotionalDiaryPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CoreData
import CloudCore

final class EmotionalDiaryPresenter {

    // MARK: - Private properties -

    private unowned let view: EmotionalDiaryViewInterface
    private let interactor: EmotionalDiaryInteractorInterface
    private let wireframe: EmotionalDiaryWireframeInterface

    var userAnnotations: [CMAnnotation] = []
    // MARK: - Lifecycle -

    init(view: EmotionalDiaryViewInterface, interactor: EmotionalDiaryInteractorInterface, wireframe: EmotionalDiaryWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension EmotionalDiaryPresenter: EmotionalDiaryPresenterInterface {
    
    func didSelectAddAction(color: EmotionalColor) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        interactor.createAnnotation(color: color)
    }
    
    
    func zoomToAnnotation(annotation: CMAnnotation) {
        //view.reloadTableView()
        wireframe.navigateAndZoomToAnnotation(annotation: annotation)
    }
    
    func object(at indexPath: IndexPath) -> CMAnnotation {
        return userAnnotations[indexPath.row]
    }
    
    func viewDidLoad() {
    }
    
    func viewWillDisappear(animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewWillAppear(animated: Bool) {
        NotificationCenter.default.addObserver(forName: .didAddRealmAnnotation, object: nil, queue: nil) { (notification) in
            log.verbose("Notifcation didAddRealmAnnotation received")
            self.syncAnnotations()
        }
        
        NotificationCenter.default.addObserver(forName: .didSyncFromCloud, object: nil, queue: nil) { (notification) in
            log.verbose("Notification didSyncFromCloud")
            self.syncAnnotations()
        }

        syncAnnotations()
        //view.reloadTableView()
    }
    
    func syncAnnotations() {
        DataManager.shared.cloudDataManager.fetchCloudAnnotations()
        userAnnotations = DataManager.shared.localDataManager.filterLocal(by: .mycolors)
        view.reloadTableView()
    }
    
    func deleteUserAnnotation(at indexPath: IndexPath) {
        let annotation = userAnnotations[indexPath.row]
        userAnnotations.remove(at: indexPath.row)
        wireframe.removeAnnotationFromMap(annotation)
    }
    
}
