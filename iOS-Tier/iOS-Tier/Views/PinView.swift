//
//  PinView.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import MapKit

internal final class PinView: MKMarkerAnnotationView {
    internal override var annotation: MKAnnotation? {
        willSet { newValue.flatMap(configure(with:)) }
    }
}

//  MARK: Configuration
private extension PinView {
    func configure(with annotation: MKAnnotation) {
        clusteringIdentifier = String(describing: PinView.self)
    }
}
