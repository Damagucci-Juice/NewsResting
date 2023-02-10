//
//  NewsResponseStorage.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation

protocol NewsResponseStorage {
    func save(queryDTO: NewsQueryDTO, response: NewsList)
    func save(categoryDTO: NewsCategoryDTO, response: NewsList)
    func getSearchResponse(_ queryDTO: NewsQueryDTO) async throws -> NewsList
    func getCategoryResponse(_ categoryDTO: NewsCategoryDTO) async throws -> NewsList
}
