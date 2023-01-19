//
//  NewsRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

final class NewsRepositoryImpl<Resource: APIResource> {
    let resource: Resource
    init(resource: Resource) {
        self.resource = resource
    }
}

extension NewsRepositoryImpl: NetworkRequest {
    func excute(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        if let urlRequest = try? resource.urlRequest() {
            load(urlRequest, withCompletion: completion)
        }
    }
    
    func decode(_ data: Data) -> Resource.ModelType? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let wrapper = try? decoder.decode(Resource.ModelType.self, from: data)
        return wrapper
    }
}


struct Wrapper<T: Decodable>: Decodable {
    let items: [T]
}
