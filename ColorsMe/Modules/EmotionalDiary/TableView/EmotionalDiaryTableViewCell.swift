//
//  EmotionalDiaryTableViewCell.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 02.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Mapbox
import MapKit

class EmotionalDiaryTableViewCell : MGSwipeTableCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func draw(_ rect: CGRect) {
        dateLabel.textColor = UIColor.darkGray
    }
    
    func configure(annotation: CMAnnotation, imageCache: ImageCache) {
        let calendar = Calendar.current
        let formatter = DateFormatter.yyyyMMddHHmmss
        let dateTitle = formatter.string(from: annotation.created!)
        
        var title = dateTitle.convertDate()
        let time = dateTitle.convertTime()

        if let date = annotation.created {
            if calendar.isDateInToday(date) {
                title = "Today"
            } else if calendar.isDateInYesterday(date) {
                title = "Yesterday"
            }
        }
        
        dateLabel.text = "\(title) - \(time)"
        coordinatesLabel.text = "\(annotation.city!), \(annotation.isocountrycode!)"

        if AppData.shouldDisplaySnapshots {
            if let cachedImage = imageCache.loadImage(for: annotation.guid!) {
                colorImage.image = cachedImage
            } else {
                indicator.startAnimating()
                takeSnapshot(coords: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude), color: annotation.color) { (image) in
                    self.indicator.stopAnimating()
                    self.colorImage.image = image
                    imageCache.setImage(image: image, for: annotation.guid!)
                }
            }
            colorImage.layer.cornerRadius = 8
            colorImage.clipsToBounds = true
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                colorImage.image = UIImage(named: "\(annotation.color!)BigDot")
            } else {
                colorImage.image = UIImage(named: "\(annotation.color!)")
            }
        }
    }
    
    func configureSwipes() {
        let shareButton = MGSwipeButton(title: "Share", icon: UIImage(systemName: "square.and.arrow.up"), backgroundColor: .gray, insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        shareButton.iconTintColor(.white)
        shareButton.centerIconOverText(withSpacing: 4)
        
        let showButton = MGSwipeButton(title: "Show", icon: UIImage(systemName: "mappin.and.ellipse"), backgroundColor: .systemBlue, insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        showButton.iconTintColor(.white)
        showButton.centerIconOverText(withSpacing: 4)
        
        let deleteButton = MGSwipeButton(title: "Delete", icon: UIImage(systemName: "trash"), backgroundColor: .red, insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        deleteButton.iconTintColor(.white)
        deleteButton.centerIconOverText(withSpacing: 4)
        
        leftButtons = [deleteButton]
        rightButtons = [showButton, shareButton]

        leftSwipeSettings.transition = .border
        rightSwipeSettings.transition = .border
        leftSwipeSettings.expandLastButtonBySafeAreaInsets = true
        rightSwipeSettings.expandLastButtonBySafeAreaInsets = true
        
        rightExpansion.buttonIndex = 0
        rightExpansion.fillOnTrigger = true

        leftExpansion.buttonIndex = 0
        leftExpansion.fillOnTrigger = true
    }
    
    
    private func takeSnapshot(coords: CLLocationCoordinate2D, color: EmotionalColor, completion: @escaping (_ image: UIImage) -> Void) {
        let backgroundQueue = DispatchQueue.global(qos: .background)
        let options = MKMapSnapshotter.Options.init()
        options.mapType = .mutedStandard
        options.region = MKCoordinateRegion(center: coords, latitudinalMeters: 150, longitudinalMeters: 150)
        options.pointOfInterestFilter = MKPointOfInterestFilter.init(including: [
            .airport,
            .beach,
            .brewery,
            .cafe,
            .winery,
            .stadium,
            .theater,
            .fitnessCenter,
            .foodMarket,
            .gasStation,
            .zoo,
            .restaurant,
            .restroom,
            .pharmacy,
            .campground
        ])
        options.size = CGSize(width: 200, height: 200)
        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.start(with: backgroundQueue) { (snapshot, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            if let snapShotImage = snapshot?.image,
                let coordinatePoint = snapshot?.point(for: coords),
                let pinImage = UIImage(named: String(describing: color)) {
                UIGraphicsBeginImageContextWithOptions(options.size, true, snapShotImage.scale)
                snapShotImage.draw(at: CGPoint.zero)
                
                let fixedPinPoint = CGPoint(x: coordinatePoint.x - (pinImage.size.width / 2), y: coordinatePoint.y - (pinImage.size.height / 2))
                pinImage.draw(at: fixedPinPoint)
                let mapImage = UIGraphicsGetImageFromCurrentImageContext()
                DispatchQueue.main.async {
                    completion(mapImage!)
                }
                UIGraphicsEndImageContext()
            }
        }
    }
}
