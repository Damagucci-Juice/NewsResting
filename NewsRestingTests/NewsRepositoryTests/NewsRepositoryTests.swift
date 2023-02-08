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
    
    func testFetchAllCategoryUsingConcurrency() async throws {   // Mark1. = 3.168s :: Mark2. = 1.120s
        //MARK: - withThrowingTaskGroup
        let allCategory = NewsCategory.allCases
        let allFetchedNewsResult = try await self.fetchAllCategoryUsingConcurrency(allCategory)
        
        XCTAssertNoThrow(allFetchedNewsResult)
        XCTAssertEqual(allCategory.count, allFetchedNewsResult.count)
    }
    
    //MARK: - with Task
    func testCompletionHandlerFetchCategoryWtihTask() throws {
        var newsList: NewsList? = nil
        let expectation = self.expectation(description: "news")
        try withTaskFooFunction(completion: { result in
            newsList = result
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(expectation)
    }
    
    //MARK: - with Completion Handler
    func testCompletionHandlerFetchCategoryWtihoutTask() throws {
        var newsList: NewsList? = nil
        let expectation = self.expectation(description: "news")
        withCompletionTaskFooFunction(completion: { result in
            newsList = result
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(expectation)
    }
}

// MARK: - Private
extension NewsRepositoryTests {
    private func fetchAllCategoryUsingConcurrency(_ allCategory: [NewsCategory]) async throws -> [NewsList] {
        return try await withThrowingTaskGroup(of: NewsList.self, returning: [NewsList].self) { taskGroup in
            
            for category in allCategory {
                taskGroup.addTask {
                    do {
                        let fetchOperation = try await self.newsRepository.fetchNews(by: category)
                        return fetchOperation
                    } catch {
                        throw NetworkError.categoryFetchFailure(category)
                    }
                }
            }
            
            var newsLists = [NewsList]()
            for try await newsList in taskGroup {
                newsLists.append(newsList)
            }
            return newsLists
        }
    }

    private func withTaskFooFunction(completion: @escaping (NewsList) -> Void) throws {
        let category = NewsCategory.science
        Task {
            do {
                let newsList = try await self.newsRepository.fetchNews(by: category)
                completion(newsList)
            } catch {
                throw NetworkError.categoryFetchFailure(category)
            }
        }
    }
    
    private func withCompletionTaskFooFunction(completion: @escaping (NewsList) -> Void) {
        let category = NewsCategory.science
        self.newsRepository.fetchNews(by: category) { list in
            Task {
                if let list = list {
                    completion(list)
                }
            }
        }
    }
}
