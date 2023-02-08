//
//  FetchCategoriesUesCase.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/08.
//

import Foundation

protocol FetchCategoriesUseCase {
    func excute() async throws -> [NewsList]
}

final class FetchCategoriesUseCaseImpl {
    private var newsRepository: NewsRepository
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
}


extension FetchCategoriesUseCaseImpl: FetchCategoriesUseCase {
    func excute() async throws -> [NewsList] {
        try await withThrowingTaskGroup(of: NewsList.self) { taskGroup in
            for category in NewsCategory.allCases {
                taskGroup.addTask {
                    do {
                        return try await self.newsRepository.fetchNews(by: category)
                    } catch {
                        throw NetworkError.categoryFetchFailure(category)
                    }
                }
            }
            
            var allNewsList = [NewsList]()
            for try await newsList in taskGroup {
                allNewsList.append(newsList)
            }
            return allNewsList
        }
    }
}
