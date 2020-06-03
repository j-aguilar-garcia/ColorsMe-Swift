//
//  EmotionalDiaryWireframe.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

final class EmotionalDiaryWireframe: BaseWireframe, TabBarViewProtocol {

    var tabIcon: UIImage = UIImage(named: "ColorMe")!
    var tabTitle: String = "Emotional Diary"
    
    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "EmotionalDiary", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: EmotionalDiaryViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = EmotionalDiaryInteractor()
        let presenter = EmotionalDiaryPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension EmotionalDiaryWireframe: EmotionalDiaryWireframeInterface {
}
