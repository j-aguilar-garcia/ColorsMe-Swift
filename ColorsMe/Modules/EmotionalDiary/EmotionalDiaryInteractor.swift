//
//  EmotionalDiaryInteractor.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CoreData

final class EmotionalDiaryInteractor {
    
    var presenter: EmotionalDiaryPresenterInterface!
}

// MARK: - Extensions -

extension EmotionalDiaryInteractor: EmotionalDiaryInteractorInterface {
    
    func createAnnotation(color: EmotionalColor) {
        AnnotationService.default.addAnnotation(color: color, byUser: true, completion: { annotation in
            self.presenter.zoomToAnnotation(annotation: annotation)
        })
    }
    
    func getUserAnnotations() -> [CMAnnotation] {
        let annotations = DataManager.shared.cloudDataManager.getAnnotations()
        return annotations
    }
    
}
