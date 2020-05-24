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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        switchMapViewAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switchMapViewAppearance()
    }

}

// MARK: - Extensions -

extension ColorMapViewController: ColorMapViewInterface {
    
    func switchMapViewAppearance() {
        if traitCollection.userInterfaceStyle == .dark {
            self.mapView.styleURL = URL(string: "mapbox://styles/spagnolo/ck0t58kmm0u0q1clfch1oum2e")
        } else {
            self.mapView.styleURL = URL(string: "mapbox://styles/spagnolo/ck0t583631r121cnuxtknci3z")
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


extension ColorMapViewController : MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MGLAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
        } else {
            annotationView?.annotation = annotation
        }
        
        
        let scaleTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.2, animations: {
            annotationView?.transform = scaleTransform
            annotationView?.layoutIfNeeded()
        }) { (isCompleted) in
            UIView.animate(withDuration: 0.3, animations: {
                annotationView?.alpha = 1.0
                annotationView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                annotationView?.layoutIfNeeded()
            })
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        log.verbose(#function)
        updateScale()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        showScale()
    }
}


extension ColorMapViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller:
        UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
