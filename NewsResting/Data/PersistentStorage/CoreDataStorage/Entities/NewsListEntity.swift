//
//  NewsListEntity.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation
import CoreData

extension NewsListEntity {
    convenience init(_ newsList: NewsList, with request: NewsQueryEntity, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.totalResults = Int32(newsList.totalResults)
        let articlesEntity = newsList.articles.map { $0.toEntity(at: self, insertInto: context) }
        self.articles = Set(articlesEntity) as NSSet
        self.request = request
    }
}

extension NewsListEntity: DomainModel {
    func toDomain() -> NewsList {
        let articles = (self.articles?.allObjects as? [NewsEntity]) ?? []
        return .init(totalResults: Int(self.totalResults),
                     articles: articles.map { $0.toDomain() })
    }
}
