//
//  EntityModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation
import CoreData
//MARK: - convert Domain Model to Entity

extension NewsList: EntityConvertable {
    func toEntity(insertInto context: NSManagedObjectContext) -> NewsListEntity {
        let entity = NewsListEntity(context: context)
        entity.totalResults = Int32(totalResults)
        articles.forEach {
            entity.addToArticles($0.toEntity(insertInto: context))
        }
        return entity
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

extension NewsQuery: EntityConvertable {
    func toEntity(insertInto context: NSManagedObjectContext) -> NewsQueryEntity {
        let entity = NewsQueryEntity(context: context)
        entity.query = query
        entity.createdAt = Date()
        return entity
    }
}
