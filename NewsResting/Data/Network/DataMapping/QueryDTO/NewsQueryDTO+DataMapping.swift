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
    let detailRequestValue: DetailSearchRequestValue?
    
    init(newsQuery: NewsQuery, page: Int) {
        self.query = newsQuery.query
        self.page = page
        self.detailRequestValue = newsQuery.detailSearchRequestValue
    }
    
    func queryParameters() -> Dictionary<String, String> {
        var dict = [String: String]()
        dict = [
            "q": self.query,
            "page": "\(self.page)"
        ]
        guard let detailRequestValue else { return dict }
        return detailRequestValue.queryParameters(in: dict)
    }
}

extension NewsQueryDTO: EntityConvertable {
    func toEntity(insertInto context: NSManagedObjectContext) -> NewsQueryEntity {
        let entity = NewsQueryEntity(context: context)
        entity.query = self.query
        entity.createdAt = Date()
        return entity
    }
}
