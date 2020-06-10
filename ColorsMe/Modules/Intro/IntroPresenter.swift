//
//  IntroPresenter.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 23.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox
import UIKit

final class IntroPresenter {

    // MARK: - Private properties -

    private unowned let view: IntroViewInterface
    private let wireframe: IntroWireframeInterface
    private let interactor: IntroInteractorInterface

    // MARK: - Lifecycle -

    init(view: IntroViewInterface, wireframe: IntroWireframeInterface, interactor: IntroInteractorInterface) {
        self.view = view
        self.wireframe = wireframe
        self.interactor = interactor
    }
}

// MARK: - Extensions -

extension IntroPresenter: IntroPresenterInterface {
    
    func didCreateAnnotation(annotation: CMAnnotation) {
        wireframe.navigate(to: .colormapwith(annotation))
    }
    
    
    func viewDidLoad() {
        view.animateSplashScreen()        
    }
    
    func didSelectSkipAction() {
        log.verbose(#function)
        wireframe.navigate(to: .colormap)
    }
    
    func didSelectAddAction(color: EmotionalColor) {
        log.verbose(#function)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        interactor.createAnnotation(with: color)
    }
    
}
