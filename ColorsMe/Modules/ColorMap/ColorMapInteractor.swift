//
//  ColorMapInteractor.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox

final class ColorMapInteractor {
    var presenter: ColorMapPresenterInterface!
}

// MARK: - Extensions -

extension ColorMapInteractor: ColorMapInteractorInterface {
    
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
}
