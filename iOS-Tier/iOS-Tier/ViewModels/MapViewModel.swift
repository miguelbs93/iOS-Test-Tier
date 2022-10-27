//
//  MapViewModel.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation
import CoreLocation

final class MapViewModel {
    private var manager: NetworkManager
    private var scooters: [Vehicle]?
    var annotations: [MapPin]?
    private var currentLocation: CLLocationCoordinate2D? {
        didSet {
            updateLocationHandler?(currentLocation)
        }
    }
    
    private lazy var locationManager: LocationManager = {
        let locationManager = LocationManager()
        return locationManager
    }()
    
    var updateMapHandler: (([MapPin]?) -> Void)?
    var updateLocationHandler: ((CLLocationCoordinate2D?) -> Void)?
    var locationErrorHandler: ((String, String) -> Void)?
    var showErrorHandler: ((String?, String?) -> Void)?
    
    var berlinCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050)
    }
    
    init(manager: NetworkManager = NetworkManager()) {
        self.manager = manager
        setupLocationManagerBindings()
    }
    
    func fetchVehicles(completion: @escaping ([Vehicle]?, NetworkError?) -> Void) {
        let request = VehiclesRequest.fetchVehicles
        manager.execute(request: request, resultType: FetchVehiclesResponse.self) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(nil, .noData)
                    return
                }
                completion(data.data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchVehicles(completion: (() -> Void)? = nil) {
        fetchVehicles {[weak self] vehicles, error in
            guard error == nil else {
                self?.showErrorHandler?("Error", error!.message)
                return
            }
            
            guard let vehicles = vehicles else {
                self?.showErrorHandler?("Error", "An error has occured, please try again later!")
                return
            }
            
            self?.scooters = vehicles
            self?.annotations = vehicles.enumerated().map { (index, element) in
                return MapPin(long: element.attributes.lng, lat: element.attributes.lat, title: element.id, batteryLevel: element.attributes.batteryLevel, maxSpeend: element.attributes.maxSpeed, hasHelmetBox: element.attributes.hasHelmetBox)
            }
            
            self?.updateMapHandler?(self?.annotations)
            completion?()
        }
    }
    
    func fetchLocation() {
        locationManager.checkLocationPermission {[weak self] error in
            if error == nil {
                // update location
                guard let location = self?.locationManager.currentLocation else { return }
                self?.currentLocation = location
            } else {
                self?.locationErrorHandler?("Error", error?.localizedDescription ?? "An error occred, please try again later!")
            }
        }
    }
    
    private func setupLocationManagerBindings() {
        locationManager.locationHandler = {[weak self] coordinates in
            guard let coordinates = coordinates else { return }
            self?.currentLocation = coordinates
        }
        
        locationManager.locationPermissionErrorHandler = {[weak self] error in
            guard let error = error else { return }
            self?.locationErrorHandler?("Error", error.localizedDescription)
        }
    }
}
