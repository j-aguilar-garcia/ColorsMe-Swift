//
//  CMAnnotationView.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 25.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import Mapbox
import UIKit

class CMAnnotationView : MGLAnnotationView {
    
    var title: String!
    var subtitle: String!
    
    override init(annotation: MGLAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let annotation = annotation as? CMAnnotation else { return }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
