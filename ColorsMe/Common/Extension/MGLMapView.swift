//
//  MGLAnnotation.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 05.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox

extension MGLMapView {
    
    func containsAnnotation(_ annotation: CMAnnotation) -> Bool {
        guard let annotations = self.annotations as? [CMAnnotation] else {
            return false
        }
        if annotations.count == 0 {
            return false
        }
        for cmannotation in annotations {
            if cmannotation.objectId == annotation.objectId {
                return true
            }
        }
        return false
    }
    
}
