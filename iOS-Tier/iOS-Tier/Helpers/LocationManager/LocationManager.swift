//
//  LocationManager.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import CoreLocation
import Foundation

enum LocationManagerErrors: Error {
    case success
    case locationServicesDisabled
    case permissionDisabled
    
    var localizedDescription: String {
        switch self {
        case .success:
            return ""
        case .locationServicesDisabled:
            return ""
        case .permissionDisabled:
            return ""
        }
    }
}

protocol LocationRequestManager {
    var manager: CLLocationManager { get set }
    func checkLocationServices()
    func checkLocationAuthorization()
}

// MARK: Implementaion

extension LocationRequestManager {
    
    func checkLocationServices(completion: @escaping (LocationManagerErrors) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization(completion: completion)
        } else {
            completion(.locationServicesDisabled)
        }
    }
    
    func checkLocationAuthorization(completion: @escaping (LocationManagerErrors) -> Void) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            completion(.success)
        case .denied:
            completion(.permissionDisabled)
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            completion(.success)
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            completion(.success)
        @unknown default:
            break
        }
    }
    
}
