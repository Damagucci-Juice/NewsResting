//
//  MockImageRepository.swift
//  NewsRestingTests
//
//  Created by YEONGJIN JANG on 2023/02/11.
//

import Foundation
@testable import NewsResting

final class MockImageRepository: ImageRepository {
    private var imageRequest: ImageRequest?
    
    func fetchImage(path: String) async throws -> Data {
        imageRequest = ImageRequest(imagePath: path)
        guard let imageRequest else { throw NetworkError.loadFailure }
        return try await imageRequest.excute()
    }
}
