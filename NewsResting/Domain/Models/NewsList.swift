//
//  NewsList.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation
import CoreData

struct NewsList: Decodable, Equatable {
    let totalResults: Int
    let articles: [News]
}

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

extension NewsList {
    func toViewModel() -> NewsListViewModel {
        .init(newsList: self)
    }
}
