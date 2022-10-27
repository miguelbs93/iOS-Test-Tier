//
//  ClusterPinView.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import MapKit

final class ClusterPinView: MKAnnotationView {
    internal override var annotation: MKAnnotation? {
        willSet {
            newValue.flatMap(configure(with:))
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0.0, y: -10.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented.")
    }
}

//  MARK: Configuration
private extension ClusterPinView {
    func configure(with annotation: MKAnnotation) {
        guard let annotation = annotation as? MKClusterAnnotation else { return }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40.0, height: 40.0))
        let count = annotation.memberAnnotations.count
        image = renderer.image { _ in
            UIColor.purple.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)).fill()
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont.appFont.bold(withSize: 20)!]
            let text = "\(count)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
