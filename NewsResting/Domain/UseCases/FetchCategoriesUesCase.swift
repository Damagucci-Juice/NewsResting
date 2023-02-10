//
//  FetchCategoriesUesCase.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/08.
//

import Foundation

protocol FetchCategoriesUseCase {
    func excute() async throws -> [NewsCategory: NewsList]
}

final class FetchCategoriesUseCaseImpl {
    private var newsRepository: NewsRepository
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
}


extension FetchCategoriesUseCaseImpl: FetchCategoriesUseCase {
    func excute() async throws -> [NewsCategory: NewsList] {
        try await withThrowingTaskGroup(of: (NewsCategory, NewsList).self) { taskGroup in
            for category in NewsCategory.allCases {
                taskGroup.addTask {
                    do {
                        let newsList = try await self.newsRepository.fetchNews(by: category)
                        return (category, newsList)
                    } catch {
                        throw NetworkError.categoryFetchFailure(category)
                    }
                }
            }
            
            var allNewsList = [NewsCategory: NewsList]()
            for try await categoryDict in taskGroup {
                allNewsList[categoryDict.0] = categoryDict.1
            }
            return allNewsList
        }
    }
}
