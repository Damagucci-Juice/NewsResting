//
//  EntityModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation
import CoreData
//MARK: - convert Domain Model to Entity

extension NewsList {
    func toEntity(with request: NewsQueryEntity ,insertInto context: NSManagedObjectContext) -> NewsListEntity {
        .init(self, with: request, insertInto: context)
    }
}

extension News {
    func toEntity(at list: NewsListEntity, insertInto context: NSManagedObjectContext) -> NewsEntity {
        .init(self, from: list, insertInto: context)
    }
}

extension NewsQuery {
    func toEntity(with response: NewsListEntity, insertInto context: NSManagedObjectContext) -> NewsQueryEntity {
        .init(self, with: response, insertInto: context)
    }
}
