//
//  CMHeatMapLayer.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 27.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox
import UIKit

class CMHeatMapLayer : CMLayer {
    
    fileprivate let identifier = "heatmaplayer"
    fileprivate let maximumZoomLevel = 17.9//8.9
        
    init(mapView: MGLMapView) {
        super.init()
        createHeatMap(mapView)
    }
    
    override func removeAllLayers(mapView: MGLMapView) {
        super.removeAllLayers(mapView: mapView)
        DispatchQueue.main.async {
            mapView.maximumZoomLevel = 18
        }
        //mapView.maximumZoomLevel = 18
    }
    
    
    private func createHeatMap(_ mapView: MGLMapView) {
        guard let annotations = mapView.annotations as? [CMAnnotation] else { return }
        var coordinates = [CLLocationCoordinate2D]()
        annotations.forEach({ coordinates.append(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)) })
        let polyline = MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))
        DispatchQueue.main.async {
            if mapView.zoomLevel > self.maximumZoomLevel {
                mapView.setZoomLevel(self.maximumZoomLevel, animated: true)
            }
        }
        let source = MGLShapeSource(identifier: "heatmaplayer", features: [polyline], options: [ .maximumZoomLevel: maximumZoomLevel ])
        mapView.maximumZoomLevel = maximumZoomLevel
        mapView.style?.addSource(source)
        layerSources.append(source)

        #warning("Change Colors?")
        let heatmapLayer = MGLHeatmapStyleLayer(identifier: "heatmaplayer", source: source)
        let colorDictionary: [NSNumber: UIColor] = [
            0.0: .clear,
            0.05: .cmHeatmapOne,
            0.1: .cmHeatmapTwo,
            0.3: .cmHeatmapThree,
            0.5: .cmHeatmapFour,
            0.7: .cmHeatmapFive,
            1: .cmHeatmapSix
        ]
        
        heatmapLayer.heatmapColor = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($heatmapDensity, 'linear', nil, %@)", colorDictionary)
         
        // Heatmap weight measures how much a single data point impacts the layer's appearance.
        heatmapLayer.heatmapWeight = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)",
        [0: 0, 16: 1])
         
        // Heatmap intensity multiplies the heatmap weight based on zoom level.
        heatmapLayer.heatmapIntensity = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
        [0: 9, 3: 3])
        heatmapLayer.heatmapRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
        [0: 7, 22: 30])
         
        // The heatmap layer should be visible up to zoom level 9.
        heatmapLayer.heatmapOpacity = NSExpression(format: "mgl_step:from:stops:($zoomLevel, 0.75, %@)", [0: 0.75, 18: 0])
        mapView.style?.addLayer(heatmapLayer)
        layerStyles.append(heatmapLayer)
        //createCircleLayer(mapView: mapView, source: source)
    }
    
    /// Add a circle layer to represent the earthquakes at higher zoom levels. (Zoomlevel > 18)
    private func createCircleLayer(mapView: MGLMapView, source: MGLSource) {
        let circleLayer = MGLCircleStyleLayer(identifier: "circle-layer", source: source)
         
        let magnitudeDictionary: [NSNumber: UIColor] = [
            0: .white,
            0.5: .yellow,
            2.5: UIColor(red: 0.73, green: 0.23, blue: 0.25, alpha: 1.0),
            5: UIColor(red: 0.19, green: 0.30, blue: 0.80, alpha: 1.0)
        ]
        circleLayer.circleColor = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)", magnitudeDictionary)
         
        // The heatmap layer will have an opacity of 0.75 up to zoom level 9, when the opacity becomes 0.
        circleLayer.circleOpacity = NSExpression(format: "mgl_step:from:stops:($zoomLevel, 0, %@)", [0: 0, 9: 0.75])
        circleLayer.circleRadius = NSExpression(forConstantValue: 20)
        mapView.style?.addLayer(circleLayer)
        layerStyles.append(circleLayer)
    }
    
}
