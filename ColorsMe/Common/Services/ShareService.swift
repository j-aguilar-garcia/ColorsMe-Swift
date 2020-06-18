//
//  ShareService.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 08.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation
import UIKit

class ShareService {
    
    static let `default` = ShareService()
    
    
    func share(annotation: CMAnnotation, for view: UIView) -> UIActivityViewController {
        let activityVC = share(guid: annotation.guid!, view: view)
        return activityVC
    }
    
    
    func share(guid: String, view: UIView) -> UIActivityViewController {
        var components = URLComponents()
        components.scheme = "https"
        components.host = AppConfiguration.default.appUrlHost
        components.path = "/"
        components.queryItems = [
            URLQueryItem(name: "id", value: guid)
        ]
        let urlToShare = components.url?.absoluteString
        let objectsToShare = [urlToShare!] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //Excluded Activities
        activityVC.excludedActivityTypes = [
            .airDrop,
            .addToReadingList,
            .openInIBooks,
            .assignToContact,
            .saveToCameraRoll,
            .markupAsPDF,
            .postToWeibo,
            .print
        ]
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popover.sourceView = view
            popover.permittedArrowDirections = .any
        }
        
        return activityVC
    }
    
    
    func shareApp() -> UIActivityViewController {
        let textToShare = "Hey!\nHow do you feel at the moment? \nPost your feeling with a click. Completely Anonymous!\nWith ColorsMe"
        let items = [URL(string: AppConfiguration.default.appStoreUrl)!, textToShare] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [
            .airDrop,
            .addToReadingList,
            .openInIBooks,
            .assignToContact,
            .saveToCameraRoll,
            .markupAsPDF,
            .postToWeibo,
            .print
        ]
        return activityVC
    }
    
}
