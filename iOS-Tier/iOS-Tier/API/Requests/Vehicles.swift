//
//  Vehicles.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

enum Vehicles {
    case fetchVehicles
}

extension Vehicles: Request {
    var path: String {
        switch self {
        case .fetchVehicles:
            return "?apiKey=\(APIConstants.apiKey)"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchVehicles:
            return .url(nil)
        }
    }
    
    var headers: [String : Any]? {
        [:]
    }
}
