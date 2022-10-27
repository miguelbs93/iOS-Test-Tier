//
//  MapPins.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 26.10.22.
//

import MapKit

class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var batteryLevel: Int?
    var maxSpeed: Int?
    var hasHelmetBox: Bool?
    var tag: Int = 0
    
    init(long: Double, lat: Double, title: String?, batteryLevel: Int?, maxSpeend: Int?, hasHelmetBox: Bool?, tag: Int = 0) {
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.title = title
        self.batteryLevel = batteryLevel
        self.maxSpeed = maxSpeend
        self.hasHelmetBox = hasHelmetBox
        self.tag = tag
    }
    
}
