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
}
