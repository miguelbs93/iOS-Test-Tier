//
//  Request.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

import Foundation

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headers: [String: Any]? { get }
}

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

public enum RequestParams {
  case body(_ : [String: Any]?)
  case url(_ : [String: Any]?)
}
