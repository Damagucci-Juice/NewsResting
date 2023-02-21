//
//  SearchNewsUseCase.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/08.
//

import Foundation

protocol SearchNewsUseCase {
    func excute(query: NewsQuery) async throws -> NewsList
}


final class SearchNewsUseCaseImpl {
    private let newsRepository: NewsRepository
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
}

extension SearchNewsUseCaseImpl: SearchNewsUseCase {
    func excute(query: NewsQuery) async throws -> NewsList {
        do {
            let fetchedNewsList = try await newsRepository.fetchNews(with: query)
            return fetchedNewsList
        } catch {
            throw NetworkError.searchFetchFailure(query)
        }
    }
}
