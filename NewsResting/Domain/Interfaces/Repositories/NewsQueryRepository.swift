//
//  NewsQueryRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

protocol NewsQueryRepository {
    func fetchRecentQuery(maxCount: Int) async throws -> [NewsQuery]
    @discardableResult
    func saveQuery(query: NewsQuery) async throws -> NewsQuery
}
