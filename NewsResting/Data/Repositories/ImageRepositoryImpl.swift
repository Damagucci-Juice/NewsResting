//
//  ImageRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/11.
//

import Foundation

final class ImageRepositoryImpl: ImageRepository {
    
    private var imageRequest: ImageRequest?
    
    func fetchImage(path: String) async throws -> Data {
        self.imageRequest = ImageRequest(imagePath: path)
        guard let imageRequest = imageRequest else { throw NetworkError.loadFailure }
        return try await imageRequest.excute()
    }
}
