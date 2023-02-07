//
//  NewsResponseStorage.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation

protocol NewsResponseStorage {
    func getResponse(query: NewsQuery) async throws -> NewsList
    func save(query: NewsQuery, response: NewsList)
}
