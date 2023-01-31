//
//  NewsQueryEntity+CoreDataProperties.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/31.
//
//

import Foundation
import CoreData


extension NewsQueryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsQueryEntity> {
        return NSFetchRequest<NewsQueryEntity>(entityName: "NewsQueryEntity")
    }

    @NSManaged public var query: String?
    @NSManaged public var createdAt: Date?

    convenience init(newsQuery: NewsQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = newsQuery.query
        createdAt = Date()
    }
}

extension NewsQueryEntity : Identifiable {
    func toDomain() -> NewsQuery {
        return .init(query: query ?? "")
    }
}
