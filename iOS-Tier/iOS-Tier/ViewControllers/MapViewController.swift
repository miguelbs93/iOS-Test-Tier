//
//  MapViewController.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 24.10.22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, AlertManager {
    lazy var pullupController: PullUpControl = {
        let pullUpVC = PullUpControl()
        pullUpVC.dataSource = self
        pullUpVC.delegate = self
        pullUpVC.setupCard(from: view)
        return pullUpVC
    }()
    
    lazy var vehicleInfoView: VehicleInfoView = {
        let view = VehicleInfoView()
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.register(ClusterPinView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        mapView.register(PinView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.delegate = self
        return mapView
    }()
    
    private var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupView()
        viewModel.fetchVehicles()
        viewModel.fetchLocation()
    }
    
    func setupBinding() {
        
        viewModel.updateMapHandler = {[weak self] annotations in
            guard let self = self else { return }
            for annotation in annotations ?? [] {
                DispatchQueue.main.async {
                    self.add(annotation: annotation)
                }
            }
        }
        
        viewModel.updateLocationHandler = {[weak self] coordinates in
            guard let coordinates = coordinates else { return }
            self?.setMapRegion(for: coordinates)
        }
        
        viewModel.showErrorHandler = {[weak self] title, message in
            let retryAction: (() -> Void) = {[weak self] in
                self?.viewModel.fetchVehicles()
            }
            let actions = ["Retry" : retryAction]
            self?.showAlertWith(title: title ?? "Error",
                                message: message ?? "An error occured, please try again later!")
        }
        
        viewModel.locationErrorHandler = {[weak self] title, message in
            self?.showPermissionError(with: title, message: message, canRetry: true)
        }
        
    }
    
    private func setupView() {
        view.addSubview(mapView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateVehicleInfo(for annotation: MapPin) {
        vehicleInfoView.populate(title: annotation.title ?? "",
                                 batteryLevel: (annotation.batteryLevel != nil) ? "\(annotation.batteryLevel!)" : "",
                                 maxSpeed: (annotation.maxSpeed != nil) ? "\(annotation.maxSpeed!)" : "",
                                 hasHelmetBox: annotation.hasHelmetBox ?? false)
    }
}

// MARK: Location Permission Error View
extension MapViewController {
    private func showPermissionError(with title: String, message: String, canRetry: Bool = false) {
        let retryAction: (() -> Void) = {[weak self] in
            self?.viewModel.fetchLocation()
        }
        let actions = ["Retry" : retryAction]
        self.showAlertWith(title: title, message: message, actions: actions)
    }
}

// MARK: Map Handlers
extension MapViewController {
    private func setMapRegion(for coordinates: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    private func add(annotation: MapPin) {
        mapView.addAnnotation(annotation)
    }
}

// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is MKClusterAnnotation:
            return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let annotation = annotation as? MapPin else { return }
        pullupController.show()
        updateVehicleInfo(for: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is ClusterPinView else { return }
        pullupController.hide()
    }
}


// MARK: PullUpViewControl Datasource
extension MapViewController: PullUpControlDataSource {
    func pullUpViewController() -> UIViewController {
        vehicleInfoView
    }
    
    func pullUpViewExpandedViewHeight() -> CGFloat {
        view.frame.size.height * 0.2
    }
}

// MARK: PullUpViewControl Delegate
extension MapViewController: PullUpControlDelegate {
    func didDismissPullUpControl() {
        guard let selectedAnnotation = mapView.selectedAnnotations.first else { return }
        mapView.deselectAnnotation(selectedAnnotation, animated: true)
    }
}
