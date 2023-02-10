//
//  NewsRepositoryTests.swift
//  NewsRestingTests
//
//  Created by YEONGJIN JANG on 2023/02/02.
//

import XCTest
@testable import NewsResting
final class NewsRepositoryTests: XCTestCase {
    
    var newsRepository: NewsRepository!
    var responseCache: NewsResponseStorage!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        responseCache = CoreDataNewsResponseStorage()
        newsRepository = NewsRepositoryImpl(responseCache: responseCache)
    }
    
    override func tearDownWithError() throws {
        responseCache = nil 
        newsRepository = nil
        try super.tearDownWithError()
    }
    
    func testSearchNews() async throws { // 1.097s
        let newsQuery = NewsQuery(query: "바나나")
        do {
            let fetchedNews = try await newsRepository.fetchNews(with: newsQuery)
            XCTAssertNoThrow(fetchedNews)
        } catch {
            throw NetworkError.searchFetchFailure(newsQuery)
        }
    }
    
    func testFetchByCategory() async throws { // 0.524s
        let newsCategory = NewsCategory.science
        do {
            let scienceNews = try await newsRepository.fetchNews(by: newsCategory)
            XCTAssertNoThrow(scienceNews)
        } catch {
            throw NetworkError.categoryFetchFailure(newsCategory)
        }
    }
}
