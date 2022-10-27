//
//  VehiclesRequest.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

enum VehiclesRequest {
    case fetchVehicles
}

extension VehiclesRequest: Request {
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
