//
//  Request.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headers: [String: Any]? { get }
}

extension Request{
    func prepareURLRequest() throws -> URLRequest {
        let urlString = "\(APIConstants.url)\(path)"
        
        guard let url = URL(string: urlString) else { throw NetworkError.incorrectURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        for header in headers! {
            urlRequest.addValue(header.value as! String, forHTTPHeaderField: header.key)
        }
        
        return urlRequest
    }
}

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

public enum RequestParams {
  case body(_ : [String: Any]?)
  case url(_ : [String: Any]?)
}
