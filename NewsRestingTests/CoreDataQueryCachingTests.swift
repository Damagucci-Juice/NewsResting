//
//  CoreDataQueryCachingTests.swift
//  NewsRestingTests
//
//  Created by YEONGJIN JANG on 2023/01/31.
//

import XCTest
@testable import NewsResting

final class CoreDataQueryCachingTests: XCTestCase {
    
    var newsQueryRepository: NewsQueryRepository!
    var newsQueryStorage: NewsQueryStorage!
    var coreDataStorage: CoreDataStorage!
    var maxCount: Int = 3
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStorage = TestCoreDataStorage()
        newsQueryStorage = CoreDataNewsQueryStorage(maxStorageLimit: maxCount,
                                                    coreDataStorage: coreDataStorage)
        newsQueryRepository = NewsQueryRepositoryImpl(newsQueryStorage: newsQueryStorage)
    }
    
    override func tearDownWithError() throws {
        coreDataStorage = nil
        newsQueryStorage = nil
        newsQueryRepository = nil
        try super.tearDownWithError()
    }
    
    func testSaveQuery() async throws {
        let queryModel = NewsQuery(query: "apple")
        let savedQuery: NewsQuery? = try await newsQueryRepository.saveQuery(query: queryModel)
        
        XCTAssertNotNil(savedQuery)
        XCTAssertEqual(savedQuery?.query, queryModel.query)
    }
    
    func testFetchRecentQueries() async throws {
        let queryModel = NewsQuery(query: "apple")
        let _: NewsQuery = try await newsQueryRepository.saveQuery(query: queryModel)
        let fetchedQueries = try await newsQueryRepository.fetchRecentQuery(maxCount: maxCount)
        
        XCTAssertNotNil(fetchedQueries)
        XCTAssertEqual(fetchedQueries.count, 1)
        XCTAssertEqual(fetchedQueries.first?.query, queryModel.query)
    }
    
    func test_Can_Store_Queires_Over_StorageLimit() async throws {
        let queries = [
            NewsQuery(query: "apple"),
            NewsQuery(query: "banana"),
            NewsQuery(query: "kiwi"),
            NewsQuery(query: "kimch"),
            NewsQuery(query: "IndexCard")
        ]
        // MARK: JUST SAVING
        for query in queries {
            let _ = try await newsQueryRepository.saveQuery(query: query)
        }
        let fetchedQueries = try await newsQueryRepository.fetchRecentQuery(maxCount: queries.count)
        
        XCTAssertEqual(fetchedQueries.count, maxCount)
        XCTAssertNotEqual(fetchedQueries.count, queries.count)
    }
}
