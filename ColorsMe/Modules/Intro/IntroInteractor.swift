//
//  IntroInteractor.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 04.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

final class IntroInteractor {
    var presenter: IntroPresenter!
}

// MARK: - Extensions -

extension IntroInteractor: IntroInteractorInterface {
    
    func createAnnotation(with color: EmotionalColor) {
        AnnotationService.default.addAnnotation(color: color, completion: { annotation in
            self.presenter.didCreateAnnotation(annotation: annotation)
        })
    }
    
    
}
