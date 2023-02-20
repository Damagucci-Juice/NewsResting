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
        guard let url = try? url()
        else { throw NetworkError.urlGeneration }
        let urlRequest = URLRequest(url: url)
        guard let data = try? await load(urlRequest) else { throw NetworkError.loadFailure }
        return data
    }
}

extension ImageRequest {
    private func url() throws -> URL {
        let path = (imagePath.hasPrefix("http") || imagePath.hasPrefix("https")) ? imagePath : "https:" + imagePath
        let koreaEncodedPath = path.makeKoreanEncoded()
        guard let url =  URL(string: koreaEncodedPath) else { throw NetworkError.urlGeneration }
        return url
    }
}
