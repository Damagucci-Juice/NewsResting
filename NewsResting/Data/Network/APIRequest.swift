//
//  NewsRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

final class APIRequest<Resource: APIResource> {
    let resource: Resource
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequestable {
    func excute() async throws -> Resource.ModelType {
        do {
            return try await load(try resource.urlRequest())
        } catch {
            throw NetworkError.loadFailure
        }
    }
    
    func decode(_ data: Data) throws -> Resource.ModelType {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            return try decoder.decode(Resource.ModelType.self, from: data)
        } catch {
            throw NetworkError.decodingFailure
        }
    }
}
