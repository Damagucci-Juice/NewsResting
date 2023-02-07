//
//  DomainConvertable + Mapping.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation

extension NewsQueryEntity: DomainConvertable {
    func toDomain() -> NewsQuery {
        .init(query: query ?? "")
    }
}

extension NewsListEntity: DomainConvertable {
    func toDomain() -> NewsList {
        let articles = (articles?.allObjects as? [NewsEntity]) ?? []
        return .init(totalResults: Int(totalResults),
                     articles: articles.map { $0.toDomain() })
    }
}

extension NewsEntity: DomainConvertable {
    func toDomain() -> News {
        .init(source: Press(id: id, name: sourceName),
              authour: author,
              title: title,
              description: subTitle,
              urlToImage: urlToImage,
              publishedAt: publishedAt ?? "",
              content: content,
              url: url)
    }
}
