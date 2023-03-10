//
//  NewsRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

protocol NewsRepository {
    func fetchNews(with query: NewsQuery, page: Int) async throws -> NewsList
    func fetchNews(by category: NewsCategory, page: Int) async throws -> NewsList
}
