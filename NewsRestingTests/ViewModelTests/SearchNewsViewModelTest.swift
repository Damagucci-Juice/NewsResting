//
//  SearchNewsViewModelTest.swift
//  NewsRestingTests
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import XCTest
@testable import NewsResting

final class SearchNewsViewModelTest: XCTestCase {
    var coreDataStorage: CoreDataStorage!
    var responseStorage: NewsResponseStorage!
    var queryStorage: NewsQueryStorage!
    var queryRepository: NewsQueryRepository!
    var newsRepository: NewsRepository!
    var useCase: SearchNewsUseCase!
    var viewModel: SearchNewsViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStorage = TestCoreDataStorage()
        queryStorage = CoreDataNewsQueryStorage(maxStorageLimit: 100, coreDataStorage: coreDataStorage)
        responseStorage = CoreDataNewsResponseStorage(coreDatastorage: coreDataStorage)
        queryRepository = NewsQueryRepositoryImpl(newsQueryStorage: queryStorage)
        newsRepository = NewsRepositoryImpl(responseCache: responseStorage)
        useCase = SearchNewsUseCaseImpl(newsRepository: newsRepository)
        viewModel = SearchNewsViewModel(usecase: useCase)
    }
    
    override func tearDownWithError() throws {
        coreDataStorage = nil
        queryStorage = nil
        responseStorage = nil
        queryRepository = nil
        newsRepository = nil
        useCase = nil
        viewModel = nil
        try super.tearDownWithError()
    }
    
    func testSearchWord() async throws {
        do {
            let newsListViewModel = try await viewModel.getNews("korea")
            
            XCTAssertNoThrow(newsListViewModel)
            XCTAssertFalse(newsListViewModel.newsViewModel.isEmpty)
        } catch {
            assertionFailure()
        }
    }
    
    func testQuerySaved() async throws {
        let words = ["color", "clock", "korea"]
        do {
            for str in words {
                _ = try await viewModel.getNews(str)
            }
            
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
            
            let queries = try await queryRepository.fetchRecentQuery(maxCount: 100)
            let results = queries.map { $0.query }

            XCTAssertNoThrow(queries)
            XCTAssertFalse(queries.isEmpty)
            XCTAssertEqual(words.sorted(), results.sorted())
        }
    }
}
