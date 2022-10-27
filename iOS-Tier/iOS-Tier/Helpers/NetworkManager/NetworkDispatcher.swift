//
//  NetworkDispatcher.swift
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

final class NetworkDispatcher: Dispatcher {
    
    private var session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    public func execute<T: Decodable>(request: Request, resultType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        do {
            let req = try prepareURLRequest(for: request)
            let dataTask = session.dataTask(with: req, completionHandler: {[weak self] (data, urlResponse, error) in
                
                do {
                    let responseObject = try self?.handleResponse(data: data, resultType: resultType)
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
    
    public func prepareURLRequest(for request: Request) throws -> URLRequest {
        
        let urlString = "\(APIConstants.url)\(request.path)"
        
        guard let url = URL(string: urlString) else { throw NetworkError.incorrectURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        for header in request.headers! {
            urlRequest.addValue(header.value as! String, forHTTPHeaderField: header.key)
        }
        
        return urlRequest
    }
    
    public func handleResponse<T: Decodable> (data: Data?, resultType: T.Type) throws -> T?{
        
        guard let data = data else { throw NetworkError.noData }
        
        do {
            let decodedItem = try decode(data: data, resultType: resultType)
            return decodedItem
        } catch {
            throw error
        }
    }
    
    public func decode<T: Decodable>(data: Data, resultType: T.Type) throws -> T? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(resultType.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError
        }
    }
    
}
