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
        
        //MARK: Saving
        let _: NewsQuery = try await newsQueryRepository.saveQuery(query: queryModel)
        //MARK: Fetching
        let fetchedQueries = try await newsQueryRepository.fetchRecentQuery(maxCount: maxCount)
        
        XCTAssertNotNil(fetchedQueries)
        XCTAssertEqual(fetchedQueries.count, 1)
        XCTAssertEqual(fetchedQueries.first?.query, queryModel.query)
    }
    
    //TODO: 현재 CoreData에 maxCount 보다 많이 저장이됨
    func test_Can_Store_Queires_Over_StorageLimit() async throws {
        let queries = makeFiveMockQueries()
        let allResults = try await withThrowingTaskGroup(
            of: NewsQuery.self,
            returning: [NewsQuery].self,
            body: { [unowned self] taskGroup in
                for query in queries {
                    taskGroup.addTask {
                        return try await self.newsQueryRepository.saveQuery(query: query)
                    }
                }
                
                var childTaskResults = [NewsQuery]()
                
                for try await savedQuery in taskGroup {
                    childTaskResults.append(savedQuery)
                }
                
                return childTaskResults
            })
        XCTAssertEqual(allResults.count, maxCount)
        XCTAssertNotEqual(allResults.count, queries.count)
    }
}

extension NewsRestingTests {
    private func makeFiveMockQueries() -> [NewsQuery] {
        let queryModel1 = NewsQuery(query: "apple")
        let queryModel2 = NewsQuery(query: "banana")
        let queryModel3 = NewsQuery(query: "kiwi")
        let queryModel4 = NewsQuery(query: "kimch")
        let queryModel5 = NewsQuery(query: "IndexCard")
        
        return [
            queryModel1,
            queryModel2,
            queryModel3,
            queryModel4,
            queryModel5
        ]
    }
}
