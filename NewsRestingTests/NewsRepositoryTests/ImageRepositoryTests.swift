//
//  ImageRepositoryTests.swift
//  NewsRestingTests
//
//  Created by YEONGJIN JANG on 2023/02/11.
//

import XCTest
import UIKit.UIImage
@testable import NewsResting

final class ImageRepositoryTests: XCTestCase {

    var imageRepository: ImageRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        imageRepository = MockImageRepository()
    }

    override func tearDownWithError() throws {
        imageRepository = nil
        try super.tearDownWithError()
    }
    
    func testFetchData() async throws {
        let data = try await imageRepository.fetchImage(path: "https://picsum.photos/200")
        XCTAssertNoThrow(data)
    }
}
