//
//  URL+Extensions.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

import Foundation

extension URL {
    var parametersComponents: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return nil }
        let items = queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
        return items
    }
}
