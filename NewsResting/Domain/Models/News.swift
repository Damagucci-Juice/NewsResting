//
//  News.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

struct News: Decodable, Equatable, Identifiable {
    var id: String? { self.source.id }
    let source: Press
    let authour: String?
    let title: String?
    let description: String? // MAKR: - Entity -> subTitle
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    let url: String?
}

extension News {
    func toViewModel() -> NewsViewModel {
        .init(news: self)
    }
}
