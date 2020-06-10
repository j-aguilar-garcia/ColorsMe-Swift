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

    private var _userAnnotations: [CMAnnotation]!
    // MARK: - Lifecycle -

    init(view: EmotionalDiaryViewInterface, interactor: EmotionalDiaryInteractorInterface, wireframe: EmotionalDiaryWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        _userAnnotations = interactor.getUserAnnotations()
    }
}

// MARK: - Extensions -

extension EmotionalDiaryPresenter: EmotionalDiaryPresenterInterface {
    
    var userAnnotations: [CMAnnotation]? {
        get {
            return _userAnnotations
        }
        set {
            _userAnnotations = interactor.getUserAnnotations()
            view.reloadTableView()
        }
    }
    
    
    func didSelectAddAction(color: EmotionalColor) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        interactor.createAnnotation(color: color)
    }
    
    
    func zoomToAnnotation(annotation: CMAnnotation) {
        //view.reloadTableView()
        wireframe.navigateAndZoomToAnnotation(annotation: annotation)
    }
    
    func object(at indexPath: IndexPath) -> CMAnnotation {
        return userAnnotations![indexPath.row]
    }
    
    func viewDidLoad() {
    }
    
    func viewWillDisappear(animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewWillAppear(animated: Bool) {
        NotificationCenter.default.addObserver(forName: .didAddRealmAnnotation, object: nil, queue: nil) { (notification) in
            log.verbose("Notifcation didAddRealmAnnotation received")
            self.userAnnotations = self.interactor.getUserAnnotations()
        }

        //userAnnotations = interactor.getUserAnnotations()
        view.reloadTableView()
    }
    
}
