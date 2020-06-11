//
//  CloudDataManagerProtocol.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 09.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import CoreData

protocol CloudDataManagerProtocol {
    
    func addAnnotation(annotation: CMAnnotation)
    
    func getUserAnnotations() -> [UserAnnotation]
    
    func getAnnotations() -> [CMAnnotation]
    
}
