//
//  NewsList.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

struct NewsList: Decodable, Equatable {
    let totalResults: Int
    let articles: [News]
}

