//
//  News.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation
import CoreData

struct News: Decodable, Equatable, Identifiable {
    var id: String? { self.source.id }
    let source: Press
    let authour: String?
    let title: String?
    let description: String? // MARK: - Entity -> subTitle
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    let url: String?
}

extension News {
    func toViewModel() -> NewsItemViewModel {
        .init(news: self)
    }
}

extension News: EntityConvertable {
    func toEntity(insertInto context: NSManagedObjectContext) -> NewsEntity {
        let entity = NewsEntity(context: context)
        entity.id = id
        entity.sourceName = source.name
        entity.author = authour
        entity.title = title
        entity.subTitle = description
        entity.urlToImage = urlToImage
        entity.publishedAt = publishedAt
        entity.content = content
        entity.url = url
        return entity
    }
}
