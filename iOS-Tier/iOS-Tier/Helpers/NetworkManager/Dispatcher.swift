//
//  Dispatcher.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

protocol Dispatcher {
    func execute<T: Decodable>(request: Request, resultType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void)
}
