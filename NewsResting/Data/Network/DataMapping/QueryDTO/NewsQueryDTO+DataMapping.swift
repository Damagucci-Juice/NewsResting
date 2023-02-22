//
//  NewsQueryDTO+DataMapping.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation
import CoreData

struct NewsQueryDTO: Encodable {
    let query: String
    let page: Int
}

extension NewsQueryDTO: EntityConvertable {
    func toEntity(insertInto context: NSManagedObjectContext) -> NewsQueryEntity {
        let entity = NewsQueryEntity(context: context)
        entity.query = self.query
        entity.createdAt = Date()
        return entity
    }
}
