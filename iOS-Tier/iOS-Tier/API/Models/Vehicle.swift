//
//  Vehicle.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

struct Vehicle: Decodable {
    let type: String
    let id: String
    let attributes: VehicleAttributes
}

struct VehicleAttributes: Decodable {
    let batteryLevel: Int
    let lat: Double
    let lng: Double
    let maxSpeed: Int
    let vehicleType: String
    let hasHelmetBox: Bool
}
