//
//  NewsQuery.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation
import CoreData

struct NewsQuery: Equatable {
    
    let query: String
    let detailSearchRequestValue: DetailSearchRequestValue?
    
    init(query: String, detailSearchRequestValue: DetailSearchRequestValue? = nil) {
        self.query = query
        self.detailSearchRequestValue = detailSearchRequestValue
    }
    
    static func == (lhs: NewsQuery, rhs: NewsQuery) -> Bool {
        lhs.query == rhs.query
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
