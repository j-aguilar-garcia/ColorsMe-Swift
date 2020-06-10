//
//  CMOverlayLayer.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 01.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox
import MapKit
import UIKit

class CMOverlayLayer : CMLayer {
    
    var polygon: MGLPolygon!
    
    init(mapView: MGLMapView, coordinates: [CLLocationCoordinate2D]) {
        super.init()
        drawPolygon(mapView: mapView, coordinates: coordinates)
    }
    
    func drawPolygon(mapView: MGLMapView, coordinates: [CLLocationCoordinate2D]) {
        polygon = MGLPolygon(coordinates: coordinates, count: UInt(coordinates.count))
        DispatchQueue.main.async {
            mapView.add(self.polygon)
        }

        var annotationsInBounds = [CMAnnotation]()

        let allAnnotations = DataManager.shared.dataManager(willRetrieveWith: .local)
        
        for anno in allAnnotations {
            let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            let polygonRenderer = MKPolygonRenderer(polygon: polygon)
            let mapPoint: MKMapPoint = MKMapPoint(anno.coordinate)
            let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)

            if polygonRenderer.path.contains(polygonViewPoint) {
                annotationsInBounds.append(anno)
            }
        }

        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations!)
        }

        log.debug("annotationsInBounds = \(annotationsInBounds.count)")
        mapView.addAnnotations(annotationsInBounds)
        mapView.setVisibleCoordinates(coordinates, count: UInt(coordinates.count), edgePadding: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30), animated: true)
    }
    
    
    func removePolygon(mapView: MGLMapView) {
        mapView.remove(polygon)
    }
}
