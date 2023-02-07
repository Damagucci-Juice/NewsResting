//
//  NewsEntity.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation
import CoreData

extension NewsEntity {
    convenience init(_ news: News, from list: NewsListEntity, insertInto context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = news.id
        self.sourceName = news.source.name
        self.author = news.authour
        self.title = news.title
        self.subTitle = news.description
        self.urlToImage = news.urlToImage
        self.publishedAt = news.publishedAt
        self.content = news.content
        self.url = news.url
        self.newsList = list
    }
}

extension NewsEntity: DomainModel {
    func toDomain() -> News {
        .init(source: Press(id: self.id, name: self.sourceName),
              authour: self.author,
              title: self.title,
              description: self.subTitle,
              urlToImage: self.urlToImage,
              publishedAt: self.publishedAt ?? "",
              content: self.content,
              url: self.url)
    }
}
