//
//  SearchNewsUseCase.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/08.
//

import Foundation

//TODO: - 이 값들을 NewsQuery에 포함시켜야할지에 대한 의문
struct SearchNewsRequestValue {
    let query: NewsQuery
    //let sortBy: 1. 최신순, 2. 유명 언론 순
    //let from - to
}

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
