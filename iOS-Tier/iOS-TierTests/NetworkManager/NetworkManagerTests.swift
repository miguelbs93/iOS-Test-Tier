//
//  NetworkManagerTests.swift
//  iOS-TierTests
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

import XCTest
@testable import iOS_Tier

final class NetworkManagerTests: XCTestCase {
    
    var sut: NetworkManager?
    
    override func setUp() async throws {
        let dispatcher = NetworkDispatcherMockup(filename: "Vehicles")
        sut = NetworkManager(dispatcher: dispatcher)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testParsingVehicleObject() {
        let json: [String: Any] = ["type": "vehicle",
                                   "id": "064396c0",
                                   "attributes": [
                                    "batteryLevel": 27,
                                    "lat": 52.475785,
                                    "lng": 13.326359,
                                    "maxSpeed": 20,
                                    "vehicleType": "escooter",
                                    "hasHelmetBox": false
                                   ]
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        let vehicle = try? sut?.parseResponse(data: jsonData, type: Vehicle.self)
        let attributes = vehicle?.attributes
        
        XCTAssertNotNil(vehicle)
        XCTAssertNotNil(attributes)
        
        XCTAssertEqual(vehicle!.type, "vehicle")
        XCTAssertEqual(vehicle!.id, "064396c0")
        XCTAssertEqual(attributes!.batteryLevel, 27)
        XCTAssertEqual(attributes!.lat, 52.475785)
        XCTAssertEqual(attributes!.lng, 13.326359)
        XCTAssertEqual(attributes!.maxSpeed, 20)
        XCTAssertEqual(attributes!.vehicleType, "escooter")
        XCTAssertEqual(attributes!.hasHelmetBox, false)
    }
    
    func testVehiclesRequest() {
        let request = VehiclesRequest.fetchVehicles
        let urlRequest = try? request.prepareURLRequest()
        
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest!.url?.scheme, "https")
        XCTAssertEqual(urlRequest!.url?.host, "api.jsonstorage.net")
        XCTAssertEqual(urlRequest!.url?.path, "/v1/json/9ec3a017-1c9d-47aa-8c38-ead2bfa9b339/c284fd9a-c94e-4bfa-8f26-3a04ddf15b47")
        
        let url = urlRequest!.url
        let components = url?.parametersComponents
        XCTAssertNotNil(components)
        XCTAssertEqual(components!["apiKey"], "9ef7d5b3-21c7-4a78-a92b-91efef42cabb")
    }
    
}
