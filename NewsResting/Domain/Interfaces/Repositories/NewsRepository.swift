//
//  NewsRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

protocol NewsRepository {
    func fetchNews(with query: NewsQuery, completion: @escaping (NewsList?) -> Void)
    func fetchNews(with category: NewsCategory, completion: @escaping (NewsList?) -> Void)
}
