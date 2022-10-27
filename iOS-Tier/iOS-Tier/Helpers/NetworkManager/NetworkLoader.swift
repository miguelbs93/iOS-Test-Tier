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

protocol NetworkHandler {
    func fetchData(with request: Request, completion: @escaping (Data?, NetworkError?) -> Void)
}

typealias APIHandler = NetworkHandler & ResponseHandler

class NetworkLoader: APIHandler {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(with request: Request, completion: @escaping (Data?, NetworkError?) -> Void) {
        do {
            let req = try request.prepareURLRequest()
            let dataTask = session.dataTask(with: req, completionHandler: { (data, urlResponse, error) in
                guard let data = data else {
                    completion(nil, nil)
                    return
                }
                completion(data, nil)
            })
            
            dataTask.resume()
        } catch {
            completion(nil, error as? NetworkError)
        }
    }
    
    public func execute<T: Decodable>(request: Request, resultType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        fetchData(with: request) {[weak self] data, error in
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
