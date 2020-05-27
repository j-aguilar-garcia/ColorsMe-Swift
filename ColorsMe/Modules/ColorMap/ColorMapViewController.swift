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
            slider.setThumbImage(UIImage(named: "Arrow"), for: .normal)
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
    
    var sideButtonsView: MenuSideButtons!
    var menuButtons : [MenuButtonView]!
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.automaticallyAdjustsContentInset = true
        mapView.locationManager.delegate = self
        // Add initial annotations
        let annotations = DataManager.shared.dataManager(willRetrieveWith: .local)
        mapView.addAnnotations(annotations)
        
        let image = UIImage(named: "Filter")!.withRenderingMode(.alwaysTemplate)
        filterButton.image = image
        filterButton.tintColor = .gray
        
        
        let triggerButton = MenuTriggerButtonView(highlightedImage: UIImage(systemName: "xmark.circle.fill")!) {
            $0.image = UIImage(systemName: "rectangle.stack.fill")
            $0.hasShadow = true
        }
        
        sideButtonsView = MenuSideButtons(parentView: self.view, triggerButton: triggerButton)
        sideButtonsView.delegate = self
        sideButtonsView.dataSource = self
        
        menuButtons = [
            MenuButtonView {
                $0.image = UIImage(named: "Defaultmap")
                $0.hasShadow = true
            },
            MenuButtonView {
                $0.image = UIImage(named: "Heatmap")
                $0.hasShadow = true
            },
            MenuButtonView {
                $0.image = UIImage(named: "Clustermap")
                $0.hasShadow = true
            }
        ]
        sideButtonsView.setTriggerButtonPosition(CGPoint(x: self.view.frame.maxX - 70, y: self.view.frame.height - 170))
        sideButtonsView.reloadButtons()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        sideButtonsView.reloadButtons()
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
    
    func hideScale(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                self.scaleView.frame = CGRect(x: self.scaleView.frame.minX - self.scaleView.frame.width - 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
            })
            updateScale()
            return
        }
        self.scaleView.frame = CGRect(x: self.scaleView.frame.minX - self.scaleView.frame.width - 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
        updateScale()
    }
    
    func showScale(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                self.scaleView.frame = CGRect(x: self.scaleView.frame.minX + self.scaleView.frame.width + 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
            })
            return
        }
        self.scaleView.frame = CGRect(x: self.scaleView.frame.minX + self.scaleView.frame.width + 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
    }
    
    func updateScale() {
        var result: Float!
        var duration: Double!
        let oldSliderValue = slider.value
        guard let visibleAnnotations = mapView.visibleAnnotations as? [CMAnnotation] else { return }

        if visibleAnnotations.count == 0 {
            result = 0.5
        } else {
            let countRedColors = visibleAnnotations.filter { $0.color! == EmotionalColor.Red }.count
            let countYellowColors = visibleAnnotations.filter { $0.color! == EmotionalColor.Yellow }.count
            let countGreenColors = visibleAnnotations.filter { $0.color! == EmotionalColor.Green }.count
            let yellowColorsValue = Float(countYellowColors) * 0.5
            result = (yellowColorsValue + Float(countGreenColors)) / (Float(countRedColors) + Float(countYellowColors) + Float(countGreenColors))
        }
        
        let isOldValueBigger = oldSliderValue > result
        let differenceBetweenValues = isOldValueBigger ? oldSliderValue - result : result - oldSliderValue

        duration = differenceBetweenValues <= 0.33 ? 1 : differenceBetweenValues > 0.33 && differenceBetweenValues <= 0.66 ? 0.8 : 0.4
        
        UIView.animate(withDuration: duration, animations: {
            self.slider.setValue(self.slider.maximumValue - result, animated: true)
        })
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
    
    
    /*
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let reuseIdentifier = "pin"
        guard let cmAnnotation = annotation as? CMAnnotation else {
            return MGLAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = CMAnnotationView(annotation: cmAnnotation, reuseIdentifier: reuseIdentifier)
        }
        return annotationView
    }*/
    
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        updateScale()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        updateScale()
        //showScale()
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

extension ColorMapViewController : MenuSideButtonsDelegate, MenuSideButtonsDataSource {
    func sideButtons(_ sideButtons: MenuSideButtons, didSelectButtonAtIndex index: Int) {
        //presenter.didSelectMenuButton(at: index)
        log.verbose("didSelectButtonAtIndx")
    }
    
    func sideButtons(_ sideButtons: MenuSideButtons, didTriggerButtonChangeStateTo state: MenuButtonState) {
        log.verbose("didTriggerButtonChangeStateTo = \(state)")
    }
    
    func sideButtonsNumberOfButtons(_ sideButtons: MenuSideButtons) -> Int {
        return menuButtons.count
    }
    
    func sideButtons(_ sideButtons: MenuSideButtons, buttonAtIndex index: Int) -> MenuButtonView {
        return menuButtons[index]
    }
    
    
}

// MARK: - PickerDialogDelegate
extension ColorMapViewController : PickerDialogDelegate {
    func pickerDialogDidChange(with annotations: [CMAnnotation]) {
        log.debug("Filtered Annotations: \(annotations.count)")
        if let currentAnnotations = self.mapView.annotations {
            self.mapView.removeAnnotations(currentAnnotations)
        }
        self.mapView.addAnnotations(annotations)
        self.mapView.showAnnotations(annotations, animated: true)
        countColorsLabel.text = "\(AppData.selectedFilterName) : \(annotations.count)"
        //showScale()
    }
    
    func pickerDialogDidClose() {
        showScale()
    }
    
}
