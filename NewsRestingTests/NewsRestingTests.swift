//
//  NewsRestingTests.swift
//  NewsRestingTests
//
//  Created by YEONGJIN JANG on 2023/01/31.
//

import XCTest
@testable import NewsResting

final class NewsRestingTests: XCTestCase {

    var newsQueryRepository: NewsQueryRepository!
    var newsQueryStorage: NewsQueryStorage!
    var coreDataStorage: CoreDataStorage!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStorage = TestCoreDataStorage()
        newsQueryStorage = CoreDataNewsQueryStorage(coreDataStorage: coreDataStorage)
        newsQueryRepository = NewsQueryRepositoryImpl(newsQueryStorage: newsQueryStorage)
    }

    override func tearDownWithError() throws {
        coreDataStorage = nil
        newsQueryStorage = nil
        newsQueryRepository = nil
        try super.tearDownWithError()
    }
    
    func testSaveQuery() {
        let queryModel = NewsQuery(query: "apple")
        let expectation = self.expectation(description: "Saving")
        var savedQuery: NewsQuery?
        
        newsQueryRepository.saveQuery(query: queryModel) { query in
            savedQuery = query
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
        XCTAssertNotNil(savedQuery)
        XCTAssertEqual(savedQuery?.query, queryModel.query)
    }
    
    /// saveQuery와 fetchRecentQuery 간에 시간 순서대로 진행되어야함
    //TODO: 시간적 직렬성을 위해 57번 라인에 sleep을 넣었는데, 없애는 방향으로 수정 필요
    func testFetchRecentQueries() {
        let queryModel = NewsQuery(query: "apple")
        let savingExpectating = self.expectation(description: "Saving")
        let fetchingExpectation = self.expectation(description: "Fetching")
        var fetchCompleted: [NewsQuery]?
        
        newsQueryRepository.saveQuery(query: queryModel) { _ in
            savingExpectating.fulfill()
        }
        
        sleep(1)
        
        newsQueryRepository.fetchRecentQuery(maxCount: 3) { fetchedQueries in
            fetchCompleted = fetchedQueries
            fetchingExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
        
        XCTAssertNotNil(fetchCompleted)
        XCTAssertEqual(fetchCompleted?.count, 1)
        XCTAssertEqual(fetchCompleted?.first?.query, queryModel.query)
    }
}
