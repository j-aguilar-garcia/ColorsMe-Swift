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
    
    
    override var description: String {
        var description = "##### Annotation #####\n"
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let name = child.label {
                description += "\(name): \(child.value)\n"
            }
        }
        return description
    }
    
    override init() {
        
    }
    
    init(annotation: RealmAnnotation) {
        self.created = annotation.created
        self.country = annotation.country
        self.title = annotation.title
        self.city = annotation.city
        self.isocountrycode = annotation.isocountrycode
        self.color = annotation.color
        self.street = annotation.street
        self.longitude = annotation.longitude as NSNumber?
        self.objectId = annotation.objectId
        self.ownerId = annotation.ownerId
        self.latitude = annotation.latitude as NSNumber?
        self.guid = annotation.guid
    }
    
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
    dynamic var isMyColor: Bool?
    
    required init() {}
    
    init(annotation: Annotation, isMyColor: Bool = false) {
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
        self.isMyColor = isMyColor
    }
    
    static func primaryKey() -> String? {
        return "objectId"
    }
    
    var description: String {
        var description = "##### RealmAnnotation #####\n"
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let name = child.label {
                description += "\(name): \(child.value)\n"
            }
        }
        return description
    }
}

class CMAnnotation : MGLPointAnnotation {
    
    var isMyColor: Bool!
    var country : String!
    var city : String!
    var isocountrycode : String!
    var color : EmotionalColor!
    var longitude : Double!
    var objectId : String?
    var latitude : Double!
    var guid : String!
    var created: Date!
    
    init(annotation: Annotation, isMyColor: Bool = false) {
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
        self.isMyColor = isMyColor
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
        self.isMyColor = annotation.isMyColor!
        coordinate = CLLocationCoordinate2D(latitude: annotation.latitude!, longitude: annotation.longitude!)
        title = annotation.title?.convertDate()
        subtitle = annotation.title?.convertTime()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var description: String {
        var description = "##### ColorAnnotation #####\n"
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let name = child.label {
                description += "\(name): \(child.value)\n"
            }
        }
        return description
    }
    
}
