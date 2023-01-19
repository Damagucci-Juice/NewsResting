//
//  NewsRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

protocol NewsRepository {
    func fetchNewsList(query: NewsQuery, completion: @escaping (Result<NewsList, Error>) -> Void) throws
}
