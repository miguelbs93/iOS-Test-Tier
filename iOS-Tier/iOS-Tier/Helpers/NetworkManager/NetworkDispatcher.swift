//
//  NetworkDispatcher.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

import Foundation

protocol Dispatcher {
    func fetchData(with request: Request, completion: @escaping (Data?, NetworkError?) -> Void)
}

struct NetworkDispatcher: Dispatcher {
    private var session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
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
}
