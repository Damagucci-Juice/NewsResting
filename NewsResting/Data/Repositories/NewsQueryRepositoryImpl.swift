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

extension NewsQueryRepositoryImpl: NewsQueryRepository {
    
    public func fetchRecentQuery(maxCount: Int, completion: @escaping ([NewsQuery]?) -> Void) {
        newsQueryStorage.fetchRecentQuries(maxCount: maxCount, completion: completion)
    }
    
    public func saveQuery(query: NewsQuery, completion: @escaping (NewsQuery?) -> Void) {
        newsQueryStorage.saveQuery(query, completion: completion)
    }
    
    func fetchRecentQuery(maxCount: Int) async throws -> [NewsQuery] {
        await withCheckedContinuation { continuation in
            fetchRecentQuery(maxCount: maxCount) { queires in
                if let queires = queires {
                    continuation.resume(returning: queires)
                } else {
                    continuation.resume(throwing:
                                            NSError(domain: QueryError.fetchError.rawValue, code: 1) as! Never
                    )
                }
            }
        }
    }
    @discardableResult
    func saveQuery(query: NewsQuery) async throws -> NewsQuery {
        await withCheckedContinuation { continuation in
            saveQuery(query: query) { savedQuery in
                if let savedQuery = savedQuery {
                    continuation.resume(returning: savedQuery)
                } else {
                    continuation.resume(throwing: NSError(domain: QueryError.saveError.rawValue, code: 1) as! Never)
                }
            }
        }
    }
}

