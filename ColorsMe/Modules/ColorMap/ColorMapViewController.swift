//
//  ColorMapViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import Mapbox
import Reachability

final class ColorMapViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: ColorMapPresenterInterface!

    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var countColorsLabel: UILabel!
        
    @IBOutlet weak var scaleView: UIView!
    @IBOutlet weak var slider: UISlider!{
        didSet {
            slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            slider.setThumbImage(UIImage.init(named: "Arrow"), for: .normal)
        }
    }
    
    @IBOutlet weak var navigationFilterButton: UIBarButtonItem!

    @IBAction func onRetryConnectionButton(_ sender: Any) {
        //NotificationCenter.default.post(name: .networkUnreachable, object: nil)
    }
    
    @IBOutlet weak var noNetworkConnectionView: UIView!
        
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBAction func onFilterButton(_ sender: Any) {
        presenter.didSelectFilterButton()
    }
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.automaticallyAdjustsContentInset = true
        mapView.locationManager.delegate = self
        
        // Add initial annotations
        let annotations = DataManager.shared.dataManager(willRetrieveWith: .local)
        mapView.addAnnotations(annotations)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //switchMapViewAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switchAppearanceFor(mapView: self.mapView)
    }

}

// MARK: - Extensions -

extension ColorMapViewController: ColorMapViewInterface {
    
    func switchAppearanceFor(mapView: MGLMapView) {
        if traitCollection.userInterfaceStyle == .dark {
            mapView.styleURL = URL(string: "mapbox://styles/spagnolo/ck0t58kmm0u0q1clfch1oum2e")
        } else {
            mapView.styleURL = URL(string: "mapbox://styles/spagnolo/ck0t583631r121cnuxtknci3z")
        }
    }
    
    func showScale(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                self.scaleView.frame = CGRect(x: self.scaleView.frame.minX - self.scaleView.frame.width - 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
            })
            return
        }
        self.scaleView.frame = CGRect(x: self.scaleView.frame.minX - self.scaleView.frame.width - 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
    }
    
    func hideScale(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                self.scaleView.frame = CGRect(x: self.scaleView.frame.minX + self.scaleView.frame.width + 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
            })
            return
        }
        self.scaleView.frame = CGRect(x: self.scaleView.frame.minX + self.scaleView.frame.width + 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
    }
    
    func updateScale() {
        
    }
    
}


// MARK: - MGLMapViewDelegate
extension ColorMapViewController : MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        guard let cmAnnotation = annotation as? CMAnnotation else { return MGLAnnotationImage() }
        let reuseIdentifier = "\(cmAnnotation.color!)"
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier)
        if annotationImage == nil {
            // lookup the image for this annotation
            let image = UIImage(named: "\(cmAnnotation.color!)")
            annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: reuseIdentifier)
        }
        return annotationImage
    }
    
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        updateScale()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        showScale()
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MGLMapView) {
        switchAppearanceFor(mapView: mapView)
    }
}


// MARK: - MGLLocationManagerDelegate

extension ColorMapViewController : MGLLocationManagerDelegate {
    
    func locationManager(_ manager: MGLLocationManager, didUpdate locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: MGLLocationManager, didUpdate newHeading: CLHeading) {
        
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: MGLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: MGLLocationManager, didFailWithError error: Error) {
        
    }
    
}

// MARK: - PopOverPresentationDelegate

extension ColorMapViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller:
        UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
