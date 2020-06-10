//
//  ImageCache.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    let queue = DispatchQueue(label: "ImageCache")
    let cache = NSCache<NSString, UIImage>()
    
    
    func setImage(image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func loadImage(for key: String) -> UIImage? {
        if let image = cache.object(forKey: key as NSString) {
            return image
        }
        return nil
    }
    
    func clear(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
