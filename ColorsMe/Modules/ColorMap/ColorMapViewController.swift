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
    
    var heatMapLayer: CMHeatMapLayer?
    var clusterMapLayer: CMClusterMapLayer?

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

        mapView.attributionButtonPosition = .topLeft

        addMenuButton()
        showMapLayer(layerType: .defaultmap)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        log.debug("")
        sideButtonsView.reloadButtons()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switchAppearanceFor(mapView: self.mapView)
    }

}

// MARK: - Extensions -

extension ColorMapViewController: ColorMapViewInterface {
    
    func showMapLayer(layerType: ColorMapLayerType, annotations: [CMAnnotation]? = nil) {
        log.debug("")
        heatMapLayer?.removeAllLayers(mapView: mapView)
        heatMapLayer = nil
        clusterMapLayer?.removeAllLayers(mapView: mapView)
        clusterMapLayer = nil
        
        if annotations != nil {
            mapView.addAnnotations(annotations!)
        } else {
            let allAnnotations = DataManager.shared.dataManager(willRetrieveWith: .local)
            if mapView.annotations?.count != allAnnotations.count {
                mapView.addAnnotations(allAnnotations)
            }
        }
        
        switch layerType {
            
        case .defaultmap:
            showScale()
            
        case .heatmap:
            hideScale(true)
            heatMapLayer = CMHeatMapLayer(mapView: mapView)
            mapView.removeAnnotations(mapView!.annotations!)
            
        case .clustermap:
            hideScale(true)
            clusterMapLayer = CMClusterMapLayer(mapView: mapView, view: view)
            mapView.removeAnnotations(mapView!.annotations!)
        }
    }
    
    
    func addMenuButton() {
        let triggerButton = MenuTriggerButtonView(highlightedImage: UIImage(systemName: "xmark.circle.fill")!) {
            $0.image = UIImage(named: "Menu")
            $0.hasShadow = false
        }
        
        sideButtonsView = MenuSideButtons(parentView: self.view, triggerButton: triggerButton)
        sideButtonsView.delegate = self
        sideButtonsView.dataSource = self
        
        menuButtons = [
            MenuButtonView {
                $0.image = UIImage(named: "Defaultmap")
                $0.hasShadow = false
            },
            MenuButtonView {
                $0.image = UIImage(named: "Heatmap")
                $0.hasShadow = false
            },
            MenuButtonView {
                $0.image = UIImage(named: "Clustermap")
                $0.hasShadow = false
            }
        ]
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 83
        log.debug("tabBarHeight = \(tabBarHeight)")
        sideButtonsView.setTriggerButtonPosition(CGPoint(x: self.view.frame.maxX - triggerButton.frame.width - 16, y: self.view.frame.height - tabBarHeight - triggerButton.frame.height - 16))
        sideButtonsView.reloadButtons()
    }
    
    
    func switchAppearanceFor(mapView: MGLMapView) {
        if traitCollection.userInterfaceStyle == .dark {
            mapView.styleURL = URL(string: "mapbox://styles/spagnolo/ck0t58kmm0u0q1clfch1oum2e")
        } else {
            mapView.styleURL = URL(string: "mapbox://styles/spagnolo/ck0t583631r121cnuxtknci3z")
        }
    }
    
    func hideScale(_ animated: Bool = true) {
        let hideScaleViewFrame = CGRect(x: 0 - self.scaleView.frame.width - 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
        
        if scaleView.frame == hideScaleViewFrame {
            return
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                self.scaleView.frame = hideScaleViewFrame
            })
            return
        }
        self.scaleView.frame = hideScaleViewFrame
    }
    
    func showScale(_ animated: Bool = true) {
        let showScaleViewFrame = CGRect(x: 0, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
        
        if scaleView.frame == showScaleViewFrame {
            return
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                self.scaleView.frame = showScaleViewFrame
            })
            updateScale()
            return
        }
        self.scaleView.frame = showScaleViewFrame
        updateScale()
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
    
    private func updateColorsLabel(count: Int) {
        countColorsLabel.text = "\(AppData.selectedFilterName) : \(count)"
    }
    
}


// MARK: - MGLMapViewDelegate
extension ColorMapViewController : MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let reuseIdentifier = "pin"
        let cmAnnotation = annotation as? CMAnnotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CMAnnotationView
        
        if annotationView == nil {
            annotationView = CMAnnotationView(annotation: cmAnnotation, reuseIdentifier: reuseIdentifier)
        }
        
        let scaleTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.2, animations: {
            annotationView!.imageView.transform = scaleTransform
            annotationView!.imageView.layoutIfNeeded()
        }) { (isCompleted) in
            UIView.animate(withDuration: 0.3, animations: {
                annotationView!.imageView.alpha = 1.0
                annotationView!.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                annotationView!.imageView.layoutIfNeeded()
            })
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        updateScale()
        
        log.debug(mapView.zoomLevel)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        updateScale()
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MGLMapView) {
        switchAppearanceFor(mapView: mapView)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        //heatMapLayer = CMHeatMapLayer(mapView: mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        //clusterMapLayer = CMClusterMapLayer(mapView: mapView, view: view)
    }
    
    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
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
        presenter.didSelectMenuButton(at: index)
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
    
    func pickerDialogDidChange(with option: PickerDialogFilterOption, annotations: [CMAnnotation]) {
        log.debug("Filtered Annotations: \(annotations.count)")
        if let currentAnnotations = self.mapView.annotations {
            self.mapView.removeAnnotations(currentAnnotations)
        }
        showMapLayer(layerType: ColorMapLayerType(rawValue: AppData.colorMapLayerItem)!, annotations: annotations)
        updateColorsLabel(count: annotations.count)
    }
    
    func pickerDialogDidClose() {
        showScale()
    }
    
}
