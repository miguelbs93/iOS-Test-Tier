//
//  FetchVehiclesResponse.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

struct FetchVehiclesResponse: Decodable {
    let data: [Vehicle]
}
