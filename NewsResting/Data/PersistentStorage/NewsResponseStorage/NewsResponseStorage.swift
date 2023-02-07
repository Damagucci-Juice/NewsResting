//
//  NewsResponseStorage.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation

protocol NewsResponseStorage {
    func getResponse(query: NewsQuery, completion: @escaping (Result<NewsList?, CoreDataStorageError>) -> Void)
    func save(query: NewsQuery, response: NewsList)
}
