//
//  CategoriesViewModelTest.swift
//  NewsRestingTests
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import XCTest
@testable import NewsResting

final class CategoriesViewModelTest: XCTestCase {
    
    var coreDataStorage: CoreDataStorage!
    var responseCache: NewsResponseStorage!
    var repository: NewsRepository!
    var usecase: FetchCategoriesUseCase!
    var categoryViewModel: CategoriesViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStorage = TestCoreDataStorage()
        responseCache = CoreDataNewsResponseStorage(coreDatastorage: coreDataStorage)
        repository = NewsRepositoryImpl(responseCache: responseCache)
        usecase = FetchCategoriesUseCaseImpl(newsRepository: repository)
        categoryViewModel = CategoriesViewModel(useCase: usecase)
    }
    
    override func tearDownWithError() throws {
        coreDataStorage = nil
        responseCache = nil
        repository = nil
        usecase = nil
        categoryViewModel = nil
        try super.tearDownWithError()
    }
    
    func testStart() async throws {
        try await categoryViewModel.start()
        
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
        
        for category in NewsCategory.allCases {
            let newsList = categoryViewModel[category]
            XCTAssertFalse(newsList.articles.isEmpty)
            XCTAssertNotEqual(newsList.totalResults, 0)
        }
    }
}
