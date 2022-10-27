//
//  FetchVehicles.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

enum Vehicles {
    case fetchVehicles
}

extension Vehicles {
    
    var path: String {
        switch self {
        case .fetchVehicles:
            return ""
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchVehicles:
            return .url(["apiKey" : APIConstants.apiKey])
        }
    }
    
    var headers: [String : Any]? {
        [:]
    }
    
}
