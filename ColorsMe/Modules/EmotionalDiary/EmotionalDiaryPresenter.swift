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

    var sections: [Section<MyColorsItem>] = [] {
        didSet {
            view.reloadTableView()
        }
    }
    // MARK: - Lifecycle -

    init(view: EmotionalDiaryViewInterface, interactor: EmotionalDiaryInteractorInterface, wireframe: EmotionalDiaryWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension EmotionalDiaryPresenter: EmotionalDiaryPresenterInterface {
    
    private var myColorsSection: Section<MyColorsItem> {
        //let items = interactor.fetchAnnotations()
        return Section(items: [
            
        ])
    }
    
    func viewDidLoad() {
        
    }
    
}
