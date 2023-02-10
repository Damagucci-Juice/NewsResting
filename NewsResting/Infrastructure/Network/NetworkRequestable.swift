//
//  NetworkRequestable.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

protocol NetworkRequestable: AnyObject {
    associatedtype ModelType
    
    func decode(_ data: Data) throws -> ModelType
    func excute() async throws -> ModelType
}

extension NetworkRequestable {
    func load(_ urlRequest: URLRequest) async throws -> ModelType {
        guard let (data, response) = try? await URLSession.shared.data(for: urlRequest)
        else { throw NetworkError.urlGeneration }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              200..<300 ~= statusCode
        else { throw NetworkError.statusCodeOutOfBound }
        guard let value = try? self.decode(data)
        else { throw NetworkError.decodingFailure }
        return value
    }
}
