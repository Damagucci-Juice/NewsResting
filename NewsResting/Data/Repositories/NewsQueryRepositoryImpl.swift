//
//  NewsQueryRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/31.
//

import Foundation

final class NewsQueryRepositoryImpl {
    private let newsQueryStorage: NewsQueryStorage
    
    init(newsQueryStorage: NewsQueryStorage) {
        self.newsQueryStorage = newsQueryStorage
    }
}

enum QueryError: String, Error {
    case saveError
    case fetchError
}

//MARK: - public
extension NewsQueryRepositoryImpl: NewsQueryRepository {

    
    func fetch(with text: String) async throws -> [(NewsQuery, NewsList)] {
        try await withCheckedThrowingContinuation  { continuation in
            newsQueryStorage.fetchRelevantQueries(text) { queryAndNewsList in
                if let queryAndNewsList = queryAndNewsList {
                    continuation.resume(returning: queryAndNewsList)
                } else {
                    continuation.resume(throwing: QueryError.fetchError)
                }
            }
        }
    }
    
    
    func fetchRecentQuery(maxCount: Int) async throws -> [(NewsQuery, NewsList)] {
        try await withCheckedThrowingContinuation { continuation in
            newsQueryStorage.fetchRecentQuries(maxCount: maxCount) { queries in
                if let queries = queries {
                    continuation.resume(returning: queries)
                } else {
                    continuation.resume(throwing:QueryError.fetchError)
                }
            }
        }
    }
    @discardableResult
    func saveQuery(query: NewsQuery, newsList: NewsList) async throws -> (NewsQuery, NewsList) {
        try await withCheckedThrowingContinuation { continuation in
            newsQueryStorage.saveQuery(query, newsList: newsList) { savedQuery in
                if let savedQuery = savedQuery {
                    continuation.resume(returning: savedQuery)
                } else {
                    continuation.resume(throwing: QueryError.saveError)
                }
            }
        }
    }
}
