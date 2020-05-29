//
//  CMLayer.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 29.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox

class CMLayer : NSObject {
    
    public var layerSources = [MGLSource]()
    public var layerStyles = [MGLStyleLayer]()
    
    func removeAllLayers(mapView: MGLMapView) {
        guard let style = mapView.style else { return }
        for layerStyle in layerStyles {
            if let styleToRemove = style.layer(withIdentifier: layerStyle.identifier) {
                style.removeLayer(styleToRemove)
            }
        }
        for source in layerSources {
            if let sourceToRemove = style.source(withIdentifier: source.identifier) {
                style.removeSource(sourceToRemove)
            }
        }
    }
    
}
