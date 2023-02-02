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
    func excute(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        if let urlRequest = try? resource.urlRequest() {
            load(urlRequest, withCompletion: completion)
        }
    }
    
    func decode(_ data: Data) throws -> Resource.ModelType {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            let model = try decoder.decode(Resource.ModelType.self, from: data)
            return model
        } catch {
            throw NetworkError.decodingFailure
        }
    }
}
