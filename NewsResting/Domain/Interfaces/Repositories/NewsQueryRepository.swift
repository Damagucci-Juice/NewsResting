//
//  NewsQueryRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

protocol NewsQueryRepository {
    func fetchRecentQuery(maxCount: Int) async throws -> [(NewsQuery, NewsList)]
    func fetch(with text: String) async throws -> [(NewsQuery, NewsList)]
    @discardableResult
    func saveQuery(query: NewsQuery, newsList: NewsList) async throws -> (NewsQuery, NewsList)
}
