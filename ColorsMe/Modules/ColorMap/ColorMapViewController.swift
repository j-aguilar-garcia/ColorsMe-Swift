//
//  ColorMapViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar-Garcia on 22.05.20.
//  Copyright (c) 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder
import Reachability
import CoreData

final class ColorMapViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: ColorMapPresenterInterface!
    var annotation: CMAnnotation!
    //var filteredAnnotations: [CMAnnotation]?

    var heatMapLayer: CMHeatMapLayer?
    var clusterMapLayer: CMClusterMapLayer?
    var searchResultsOverlay: CMOverlayLayer?

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
    @IBOutlet weak var retryConnectionButton: UIButton!
    
    @IBOutlet weak var noNetworkConnectionView: UIView!
        
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBAction func onFilterButton(_ sender: Any) {
        presenter.didSelectFilterButton()
    }
    
    // Menu Buttons
    var sideButtonsView: MenuSideButtons!
    var menuButtons : [MenuButtonView]!
    
    // Searchbar
    var resultSearchController: UISearchController?
    var locationSearchWireframe: LocationSearchWireframe!

    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        addReachabilityObserver()
        mapView.delegate = self
        mapView.automaticallyAdjustsContentInset = true

        mapView.attributionButtonPosition = .topLeft
        mapView.setCenter(LocationService.default.currentLocation(), animated: false)
        addMenuButton()
        
        setUpSearchBar()
        showMapLayer(layerType: .defaultmap)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        log.debug("")
        sideButtonsView.reloadButtons()
        presenter.shouldUpdateScale(mapView, slider.value)
        presenter.viewWillAppear(animated: animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switchAppearanceFor(mapView: self.mapView)
    }

}

// MARK: - Extensions -

extension ColorMapViewController: ColorMapViewInterface, EmotionalDiaryDelegate {
    
    func showAnnotations(_ annotations: [CMAnnotation], animated: Bool) {
        var coordinates = [CLLocationCoordinate2D]()
        annotations.forEach({ coordinates.append($0.coordinate) })
        mapView.setVisibleCoordinates(coordinates, count: UInt(coordinates.count), edgePadding: UIEdgeInsets(top: 30, left: 60, bottom: 30, right: 30), animated: animated)
    }
    
    func removeAnnotation(_ annotation: CMAnnotation) {
        if mapView.containsAnnotation(annotation) {
            log.debug("Contains Annotation To Remove From Map = true")
            mapView.removeAnnotations([annotation])
        }
        mapView.removeAnnotation(annotation)
        presenter.shouldUpdateScale(mapView, slider.value)
        let layerType = ColorMapLayerType(rawValue: AppData.colorMapLayerItem)!
        showMapLayer(layerType: layerType)
    }
    
    func addAnnotation(_ annotation: CMAnnotation) {
        if mapView.containsAnnotation(annotation) {
            return
        }
        mapView.addAnnotation(annotation)
        presenter.shouldUpdateScale(mapView, slider.value)
        showMapLayer(layerType: .defaultmap)
    }
    
    
    func zoomToAnnotation(annotation: CMAnnotation) {
        mapView.addAnnotation(annotation)
        presenter.shouldUpdateScale(mapView, slider.value)
        showMapLayer(layerType: .defaultmap)
        mapView.selectAnnotation(annotation, animated: true, completionHandler: {
            self.mapView.setCenter(annotation.coordinate, zoomLevel: 8, animated: true)
            let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, altitude: 2500, pitch: 50, heading: 180)
            self.mapView.setCamera(camera, withDuration: 3.5, animationTimingFunction: CAMediaTimingFunction(name: .easeInEaseOut))
        })
    }
    
    
    func showMapLayer(layerType: ColorMapLayerType, annotations: [CMAnnotation]? = nil) {
        log.debug("")
        AppData.colorMapLayerItem = layerType.rawValue

        heatMapLayer?.removeAllLayers(mapView: mapView)
        heatMapLayer = nil
        clusterMapLayer?.removeAllLayers(mapView: mapView)
        clusterMapLayer = nil
        willRemoveOverlay()
        
        if annotations != nil {
            mapView.addAnnotations(annotations!)
        } else {
            if mapView.annotations != nil {
                mapView.removeAnnotations(mapView.annotations!)
            }
            let allAnnotations = DataManager.shared.dataManager(willRetrieveWith: .local)
            if mapView.annotations?.count != allAnnotations.count {
                mapView.addAnnotations(allAnnotations)
            }
        }
        updateColorsLabel(count: mapView.annotations?.count ?? 0)
        
        switch layerType {
            
        case .defaultmap:
            showScale(true)
            break
            
        case .heatmap:
            hideScale(true)
            heatMapLayer = CMHeatMapLayer(mapView: mapView)
            if mapView.annotations != nil, !mapView.annotations!.isEmpty {
                mapView.removeAnnotations(mapView!.annotations!)
            }
            break
            
        case .clustermap:
            hideScale(true)
            clusterMapLayer = CMClusterMapLayer(mapView: mapView, view: view)
            if mapView.annotations != nil, !mapView.annotations!.isEmpty {
                mapView.removeAnnotations(mapView!.annotations!)
            }
            break
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
        scaleView.frame = CGRect(x: 0, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
        
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
        scaleView.frame = CGRect(x: 0 - self.scaleView.frame.width - 8, y: self.scaleView.frame.minY, width: self.scaleView.frame.width, height: self.scaleView.frame.height)
        
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                self.scaleView.frame = showScaleViewFrame
            }) { finish in
                self.presenter.shouldUpdateScale(self.mapView, self.slider.value)
            }
            return
        }
        self.scaleView.frame = showScaleViewFrame
        presenter.shouldUpdateScale(mapView, slider.value)
    }
    
    func updateScale(value: Float, duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.slider.setValue(self.slider.maximumValue - value, animated: true)
        })
    }
    
    private func updateColorsLabel(count: Int, name: String = "") {
        if name.isEmpty {
            countColorsLabel.text = "\(AppData.selectedFilterName) : \(count)"
        } else {
            countColorsLabel.text = "\(name) : \(count)"
        }
    }
    
}


// MARK: - MGLMapViewDelegate
extension ColorMapViewController : MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let cmAnnotation = annotation as? CMAnnotation
        let reuseIdentifier = String(describing: cmAnnotation?.color!.rawValue)
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
        presenter.shouldUpdateScale(mapView, slider.value)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        //showScale()
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        log.verbose("callout tapped")
        guard let annotation = annotation as? CMAnnotation else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let vc = ShareService.default.share(annotation: annotation, for: self.view)
        self.present(vc, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        log.verbose("rightCalloutAccessoryViewFor")
        guard let annotation = annotation as? CMAnnotation else {
            return UIView()
        }
        
        let isUserAnnotation = presenter.checkForUserAnnotation(annotation: annotation)
        if annotation.isMyColor || isUserAnnotation {
            let shareButton = UIButton(type: .custom)
            let shareButtonImage = UIImage(systemName: "square.and.arrow.up")
            shareButton.setImage(shareButtonImage, for: .normal)
            shareButton.imageView?.contentMode = .scaleAspectFit
            shareButton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 40))
            return shareButton
        }

        return UIView()
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MGLMapView) {
        switchAppearanceFor(mapView: mapView)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        //heatMapLayer = CMHeatMapLayer(mapView: mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        presenter.viewDidLoad()
        //clusterMapLayer = CMClusterMapLayer(mapView: mapView, view: view)
    }
    
    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 2
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .cmPolylineStroke
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return .cmPolylineFill
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
        presenter.didSelectMenuButton(at: index, mapView: mapView)
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
        if self.mapView.annotations != nil {
            self.mapView.removeAnnotations(self.mapView.annotations!)
        }
        presenter.filteredAnnotationsDidChange(annotations)
        hideScale()
        showMapLayer(layerType: ColorMapLayerType(rawValue: AppData.colorMapLayerItem)!, annotations: annotations)
    }
    
    func pickerDialogDidClose() {
        //showScale()
    }
    
}

extension ColorMapViewController : UISearchBarDelegate {
    
    private func setUpSearchBar() {
        locationSearchWireframe = LocationSearchWireframe()
        locationSearchWireframe.delegate = self
        let locationSearchTable = locationSearchWireframe.viewController as! LocationSearchViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        
        resultSearchController?.searchBar.sizeToFit()
        resultSearchController?.searchBar.barTintColor = .green
        resultSearchController?.searchBar.searchBarStyle = .prominent
        resultSearchController?.searchBar.autocorrectionType = .default
        resultSearchController?.searchBar.textContentType = .addressCityAndState
        resultSearchController?.searchBar.placeholder = "Find places"
        
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        willRemoveOverlay()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        willRemoveOverlay()
    }

}

extension ColorMapViewController : LocationSearchDelegate {
    
    func didRetrieveCoordinates(coordinates: [CLLocationCoordinate2D], placemark: GeocodedPlacemark) {
        log.debug("")
        AppData.selectedFilterIndex = 0
        showMapLayer(layerType: .defaultmap)
        resultSearchController?.searchBar.text = placemark.qualifiedName
        searchResultsOverlay = CMOverlayLayer(mapView: self.mapView, coordinates: coordinates)
        updateColorsLabel(count: mapView.annotations?.count ?? 0, name: placemark.name)
    }
    
    func willRemoveOverlay() {
        if searchResultsOverlay != nil {
            searchResultsOverlay?.removePolygon(mapView: mapView)
            searchResultsOverlay = nil
            showMapLayer(layerType: .defaultmap)
        }
    }
    
}



extension ColorMapViewController: ReachabilityObserverProtocol {
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            self.noNetworkConnectionView.isHidden = false
            self.retryConnectionButton.isEnabled = false
        } else {
            self.noNetworkConnectionView.isHidden = true
            self.retryConnectionButton.isEnabled = true
            DataManager.shared.fetchData()
        }
    }
    
}
