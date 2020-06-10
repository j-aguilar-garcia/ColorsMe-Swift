//
//  RemoteDataManagerInputProtocol.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

protocol RemoteDataManagerInputProtocol {
    
    func initBackendless()
    
    var annotations: [CMAnnotation] { get set }
        
    func saveToBackendless(annotation: Annotation, completion: @escaping (_ annotation: Annotation) -> Void)
    
    func updateToBackendless(annotation: Annotation)
    
    func deleteFromBackendless(annotation: Annotation)
    
    func deleteFromBackendless(by id: String)
}
