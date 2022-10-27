//
//  ResponseHandler.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 25.10.22.
//

import Foundation

protocol ResponseHandler {
    func parseResponse<T: Decodable>(data: Data, type: T.Type) throws -> T?
}

extension ResponseHandler {
    func parseResponse<T: Decodable>(data: Data, type: T.Type) throws -> T? {
        do {
            let model = try JSONDecoder().decode(type, from: data)
            return model
        } catch let DecodingError.dataCorrupted(context) {
            throw DecodingError.dataCorrupted(context)
        } catch let DecodingError.keyNotFound(key, context) {
            throw DecodingError.keyNotFound(key, context)
        } catch let DecodingError.valueNotFound(value, context) {
            throw DecodingError.valueNotFound(value, context)
        } catch let DecodingError.typeMismatch(type, context) {
            throw DecodingError.typeMismatch(type, context)
        } catch {
            throw error
        }
    }
}
