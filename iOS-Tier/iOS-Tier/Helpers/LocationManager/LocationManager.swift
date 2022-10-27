//
//  LocationManager.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import CoreLocation
import Foundation

enum LocationManagerError: Error {
    case locationServicesDisabled
    case denied
    case restricted
    case managerError
    
    var localizedDescription: String {
        switch self {
        case .locationServicesDisabled:
            return "Location Services Disabled!"
        case .denied:
            return "Location Access Request Denied!"
        case .restricted:
            return "Location access restricted, go to the settings and update it to try again!"
        case .managerError:
            return "Location Manager Error!"
        }
    }
}

final class LocationManager: NSObject {
    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    var locationHandler: ((CLLocationCoordinate2D?) -> Void)?
    var locationPermissionErrorHandler: ((LocationManagerError?) -> Void)?
    
    var currentLocation: CLLocationCoordinate2D? {
        manager.location?.coordinate
    }
    
    func checkLocationPermission(completion: ((LocationManagerError?) -> Void)? = nil) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            completion?(nil)
            
        case .denied:
            completion?(.denied)
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            completion?(.restricted)
            
        @unknown default:
            break
        }
    }
}


// MARK: CLLocationManager Delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission {[weak self] error in
            self?.locationPermissionErrorHandler?(error)
        }
    }
}
