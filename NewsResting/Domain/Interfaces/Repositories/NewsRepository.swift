//
//  NewsRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

protocol NewsRepository {
    func fetchNews(with query: NewsQuery, completion: @escaping (NewsList?) -> Void)
    //TODO: 카테고리별 뉴스 도입
//    func fetchNews(with category: NewsCategory, completion: @escaping (NewsList?) -> Void)
}
