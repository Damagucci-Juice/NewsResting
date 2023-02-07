//
//  NewsQueryEntity.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation
import CoreData

extension NewsQueryEntity {
    convenience init(_ query: NewsQuery, with response: NewsListEntity, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.query = query.query
        self.createdAt = Date()
        self.response = response
    }
}

extension NewsQueryEntity: DomainModel {
    func toDomain() -> NewsQuery {
        .init(query: self.query ?? "")
    }
}
