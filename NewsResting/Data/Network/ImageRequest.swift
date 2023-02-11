//
//  ImageRequest.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/11.
//

import Foundation

final class ImageRequest {
    var imagePath: String
    
    init(imagePath: String) {
        self.imagePath = imagePath
    }
}

extension ImageRequest: NetworkRequestable {
    func decode(_ data: Data) throws -> Data {
        data
    }
    
    func excute() async throws -> Data {
        guard let url = URL(string: imagePath)
        else { throw NetworkError.urlGeneration }
        let urlRequest = URLRequest(url: url)
        guard let data = try? await load(urlRequest) else { throw NetworkError.loadFailure }
        return data
    }
}
