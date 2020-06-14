//
//  EmotionalDiaryInterfaces.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

protocol EmotionalDiaryDelegate {
    func zoomToAnnotation(annotation: CMAnnotation)
    func removeAnnotation(_ annotation: CMAnnotation)
}

protocol EmotionalDiaryWireframeInterface: WireframeInterface {
    func navigateAndZoomToAnnotation(annotation: CMAnnotation)
    func removeAnnotationFromMap(_ annotation: CMAnnotation)
}

protocol EmotionalDiaryViewInterface: ViewInterface {
    func reloadTableView()
}

protocol EmotionalDiaryPresenterInterface: PresenterInterface {
    var userAnnotations: [CMAnnotation] { get }
    func object(at: IndexPath) -> CMAnnotation
    func zoomToAnnotation(annotation: CMAnnotation)
    func didSelectAddAction(color: EmotionalColor)
    func syncAnnotations()
    func deleteUserAnnotation(at indexPath: IndexPath)
}

protocol EmotionalDiaryInteractorInterface: InteractorInterface {
    func createAnnotation(color: EmotionalColor)
    func getUserAnnotations() -> [CMAnnotation]
}

enum MyColorsItem {
    case myColors(CMAnnotation)
}

enum CornerSide {
    case bottom
    case top
}
