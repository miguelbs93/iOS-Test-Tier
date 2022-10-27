//
//  NetworkLoader.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

enum NetworkError: Error {
    case badInput
    case decodingError
    case incorrectURL
    case noData
    case noConnection
    case unknown
    
    var message: String {
        switch self {
        case .noConnection:
            return "Kindly check your internet connection and try again later!"
        default:
            return "An error occured, please try again later!"
        }
    }
}

class NetworkManager: ResponseHandler {
    let dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher = NetworkDispatcher()) {
        self.dispatcher = dispatcher
    }
    
    public func execute<T: Decodable>(request: Request, resultType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        dispatcher.fetchData(with: request) {[weak self] data, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let responseObject = try self?.parseResponse(data: data, type: T.self)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error as! NetworkError))
            }
        }
    }
}
