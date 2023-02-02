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
    var newsListViewModel: NewsListViewModel!
    override func setUpWithError() throws {
        try super.setUpWithError()
        newsRepository = NewsRepositoryImpl()
        newsListViewModel = NewsListViewModel(newsRepository: newsRepository)
    }
    
    override func tearDownWithError() throws {
        newsRepository = nil
        newsListViewModel = nil
        try super.tearDownWithError()
    }
    
    func testSearchNews() { // 1.078s
        let newsQuery = NewsQuery(query: "banana")
        var fetchedNews: [News]?
        let expectation = self.expectation(description: "search banana")
        
        newsRepository.fetchNews(with: newsQuery) { newsList in
            fetchedNews = newsList != nil ? newsList?.articles : nil
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertNotNil(fetchedNews)
    }
    
    func testFetchByCategory() { // 1.141s
        let newsCategory = NewsCategory.technology
        var fetchedNews: [News]?
        let expectation = self.expectation(description: "fetch science category")
        
        newsRepository.fetchNews(by: newsCategory) { newsList in
            fetchedNews = newsList != nil ? newsList?.articles : nil
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertNotNil(fetchedNews)
    }
    
    func testFetchAllCategoryUsingSerial() async throws { // 2.857
        let allCategory = NewsCategory.allCases
        var newsLists = [NewsList]()
        
        for category in allCategory {
            do {
                let fetchedCategoryNewsList = try await newsRepository.fetchNews(by: category)
                newsLists.append(fetchedCategoryNewsList)
            } catch {
                print(category)
            }
        }
        
        XCTAssertEqual(newsLists.count, allCategory.count)
    }
    
    func testFetchAllCategoryUsingConcurrency() async throws {
        let allCategory = NewsCategory.allCases
        let allFetchedNewsResult = try await self.fetchAllCategoryUsingConcurrency(allCategory)
        XCTAssertNoThrow(allFetchedNewsResult)
        XCTAssertEqual(allCategory.count, allFetchedNewsResult.count)
    }
}


extension NewsRepositoryTests {
    public func fetchAllCategoryUsingConcurrency(_ allCategory: [NewsCategory]) async throws -> [NewsList?] {
        
        return try await withThrowingTaskGroup(of: NewsList?.self, returning: [NewsList?].self) {  taskGroup in
            
            for category in allCategory {
                taskGroup.addTask {
                    do {
                        let fetchOperation = try await self.newsRepository.fetchNews(by: category)
                        return fetchOperation
                    } catch {
                        print(category)
                        return nil
                    }
                }
            }
            
            var allCategoryNewsList = [NewsList?]()
            for try await newsList in taskGroup {
                allCategoryNewsList.append(newsList)
            }
            return allCategoryNewsList
        }
    }

}
