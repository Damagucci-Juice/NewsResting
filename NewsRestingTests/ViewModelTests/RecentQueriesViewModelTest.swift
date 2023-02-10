//
//  RecentQueriesViewModelTest.swift
//  NewsRestingTests
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import XCTest
@testable import NewsResting

class RecentQueriesViewModelTest: XCTestCase {

    var coreDataStorage: CoreDataStorage!
    var storage: NewsQueryStorage!
    var repository: NewsQueryRepository!
    var useCase: FetchRecentQueriesUseCase!
    var viewModel: RecentQueriesViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStorage = TestCoreDataStorage()
        storage = CoreDataNewsQueryStorage(coreDataStorage: coreDataStorage)
        repository = NewsQueryRepositoryImpl(newsQueryStorage: storage)
        useCase = FetchRecentQueriesUseCaseImpl(queryRepository: repository)
        viewModel = RecentQueriesViewModel(fetchRecentQueriesUseCase: useCase)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        useCase = nil
        repository = nil
        storage = nil
        coreDataStorage = nil 
    }
    
    func testFetchRecentQueries() async throws {
        let query = NewsQuery(query: "chicken")
        
        do {
            try await repository.saveQuery(query: query)
            try await viewModel.fetchQuereis()
            XCTAssertEqual(viewModel.queries.first!, query)
            XCTAssertFalse(viewModel.queries.isEmpty)
        } catch {
            assertionFailure()
        }
    }
}
