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
    
    
    
    func viewDidLoad() {
        
    }
    
    
    func deleteUserAnnotation(id: String) {
        let annotation = interactor.annotation(by: id)
        wireframe.removeAnnotationFromMap(annotation)
    }
}
