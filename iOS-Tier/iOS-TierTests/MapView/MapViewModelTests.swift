//
//  MapViewModelTests.swift
//  iOS-TierTests
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

import XCTest
@testable import iOS_Tier

final class MapViewModelTests: XCTestCase {
    
    var sut: MapViewModel?
    
    override func setUp() async throws {
        let dispatcher = NetworkDispatcherMockup(filename: "Vehicles")
        let networkManager = NetworkManager(dispatcher: dispatcher)
        sut = MapViewModel(loader: networkManager)
    }
    
    override func tearDown() {
        sut = nil
    }
    
}
