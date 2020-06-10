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
    var imageView: UIImageView!
    
    override init(annotation: MGLAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let cmAnnotation = annotation as? CMAnnotation else { return }
        self.title = cmAnnotation.title!
        self.subtitle = cmAnnotation.subtitle!
        let color = String(describing: cmAnnotation.color!)
        self.imageView = UIImageView(image: UIImage(named: color))
        self.addSubview(self.imageView)
        self.frame = self.imageView.frame
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
