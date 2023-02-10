//
//  NewsRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

protocol NewsRepository {
    func fetchNews(with query: NewsQuery) async throws -> NewsList
    func fetchNews(by category: NewsCategory) async throws -> NewsList
}
