//
//  NewsCategoryDTO+DataMapping.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import Foundation
import CoreData

struct NewsCategoryDTO: Encodable {
    let category: String
    let page: Int
}

extension NewsCategoryDTO: EntityConvertable {
    func toEntity(insertInto context: NSManagedObjectContext) -> NewsCategoryEntity {
        let entity = NewsCategoryEntity(context: context)
        entity.category = self.category
        entity.page = Int64(self.page)
        return entity
    }
}
