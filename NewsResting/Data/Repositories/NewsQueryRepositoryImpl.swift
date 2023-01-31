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

extension NewsQueryRepositoryImpl: NewsQueryRepository {
    public func fetchRecentQuery(maxCount: Int, completion: @escaping ([NewsQuery]?) -> Void) {
        newsQueryStorage.fetchRecentQuries(maxCount: maxCount, completion: completion)
    }
    
    public func saveQuery(query: NewsQuery) {
        newsQueryStorage.saveQuery(query)
    }
}

