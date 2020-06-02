//
//  Annotation.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 24.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import Backendless
import Mapbox
import Unrealm
import Realm

@objcMembers class Annotation: NSObject {
    
    dynamic var created : Date?
    dynamic var country : String?
    dynamic var updated : Date?
    dynamic var title : String?
    dynamic var city : String?
    dynamic var isocountrycode : String?
    dynamic var color : String?
    dynamic var street : String?
    dynamic var longitude : NSNumber?
    dynamic var objectId : String?
    dynamic var ownerId : String?
    dynamic var latitude : NSNumber?
    dynamic var guid : String?
    
    
}

class RealmAnnotation: Realmable {
    
    dynamic var created : Date?
    dynamic var country : String?
    dynamic var title : String?
    dynamic var city : String?
    dynamic var isocountrycode : String?
    dynamic var color : String?
    dynamic var street : String?
    dynamic var longitude : Double?
    dynamic var objectId : String?
    dynamic var ownerId : String?
    dynamic var latitude : Double?
    dynamic var guid : String?
    
    required init() {}
    
    init(annotation: Annotation) {
        self.country = annotation.country!
        self.city = annotation.city!
        self.isocountrycode = annotation.isocountrycode!
        self.color = annotation.color!
        self.longitude = annotation.longitude?.doubleValue
        self.latitude = annotation.latitude?.doubleValue
        self.objectId = annotation.objectId
        self.guid = annotation.guid!
        self.created = annotation.created
        self.ownerId = annotation.ownerId
        self.street = annotation.street
        self.title = annotation.title
    }
    
    static func primaryKey() -> String? {
        return "objectId"
    }
}

class CMAnnotation : MGLPointAnnotation {
    
    var isMyColor: Bool = false
    var country : String!
    var city : String!
    var isocountrycode : String!
    var color : EmotionalColor!
    var longitude : Double!
    var objectId : String!
    var latitude : Double!
    var guid : String!
    var created: Date!
    
    init(annotation: Annotation) {
        super.init()
        self.country = annotation.country!
        self.city = annotation.city!
        self.isocountrycode = annotation.isocountrycode!
        self.color = EmotionalColor(rawValue: annotation.color!)
        self.longitude = annotation.longitude?.doubleValue
        self.latitude = annotation.latitude?.doubleValue
        self.objectId = annotation.objectId
        self.guid = annotation.guid!
        self.created = annotation.created
        coordinate = CLLocationCoordinate2D(latitude: annotation.latitude!.doubleValue, longitude: annotation.longitude!.doubleValue)
        title = annotation.title?.convertDate()
        subtitle = annotation.title?.convertTime()
    }
    
    
    init(annotation: RealmAnnotation) {
        super.init()
        self.country = annotation.country!
        self.city = annotation.city!
        self.isocountrycode = annotation.isocountrycode!
        self.color = EmotionalColor(rawValue: annotation.color!)
        self.longitude = annotation.longitude
        self.latitude = annotation.latitude
        self.objectId = annotation.objectId!
        self.guid = annotation.guid!
        self.created = annotation.created!
        coordinate = CLLocationCoordinate2D(latitude: annotation.latitude!, longitude: annotation.longitude!)
        title = annotation.title?.convertDate()
        subtitle = annotation.title?.convertTime()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
