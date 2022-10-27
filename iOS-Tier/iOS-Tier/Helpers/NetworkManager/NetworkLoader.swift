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
    case unknown
}

class NetworkLoader: ResponseHandler {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func execute<T: Decodable>(request: Request, resultType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        do {
            let req = try request.prepareURLRequest()
            let dataTask = session.dataTask(with: req, completionHandler: {[weak self] (data, urlResponse, error) in
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
            })
            
            dataTask.resume()
        } catch {
            completion(.failure(error as! NetworkError))
        }
    }
    
}
