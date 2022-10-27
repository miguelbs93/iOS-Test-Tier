//
//  MapViewModelTests.swift
//  iOS-TierTests
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

import XCTest
@testable import iOS_Tier
import CoreLocation

final class MapViewModelTests: XCTestCase {
    
    var sut: MapViewModel?
    
    override func setUp() async throws {
        let dispatcher = NetworkDispatcherMockup(filename: "Vehicles")
        let networkManager = NetworkManager(dispatcher: dispatcher)
        sut = MapViewModel(manager: networkManager)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testFetchVehicles() {
        let expectation = expectation(description: "completion")
        
        var responseError: NetworkError?
        var responseVehicles: [Vehicle]?
        
        sut?.fetchVehicles(completion: { vehicles, error in
            responseError = error
            responseVehicles = vehicles
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseVehicles)
        XCTAssertEqual(responseVehicles!.count, 3)
        
        let vehicle = responseVehicles!.first
        let attributes = vehicle!.attributes
        
        XCTAssertEqual(vehicle!.type, "vehicle")
        XCTAssertEqual(vehicle!.id, "064396c0")
        XCTAssertEqual(attributes.batteryLevel, 27)
        XCTAssertEqual(attributes.lat, 52.475785)
        XCTAssertEqual(attributes.lng, 13.326359)
        XCTAssertEqual(attributes.maxSpeed, 20)
        XCTAssertEqual(attributes.vehicleType, "escooter")
        XCTAssertEqual(attributes.hasHelmetBox, false)
    }
    
    func testFetchVehicleAnnotations() {
        let expectation = expectation(description: "completion")
        
        sut?.fetchVehicles(completion: {
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(sut?.annotations?.count ?? 0, 3)
        
        let annotation = sut!.annotations!.first
        
        XCTAssertEqual(annotation!.title, "064396c0")
        XCTAssertEqual(annotation!.batteryLevel, 27)
        XCTAssertEqual(annotation!.coordinate.latitude, 52.475785)
        XCTAssertEqual(annotation!.coordinate.longitude, 13.326359)
        XCTAssertEqual(annotation!.maxSpeed, 20)
        XCTAssertEqual(annotation!.hasHelmetBox, false)
    }
}
