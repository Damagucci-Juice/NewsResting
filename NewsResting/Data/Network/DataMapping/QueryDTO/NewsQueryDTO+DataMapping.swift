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
}

extension NewsQueryDTO: EntityConvertable {
    func toEntity(insertInto context: NSManagedObjectContext) -> NewsQueryEntity {
        let entity = NewsQueryEntity(context: context)
        entity.query = self.query
        entity.createdAt = Date()
        return entity
    }
}

//struct NewsQueryRequestDTO: Encodable {
//    enum LanguageDTO: String, CaseIterable, Encodable {
//        case arabic = "ar"
//        case german = "de"
//        case english = "en"
//        case spanish = "es"
//        case french = "fr"
//        case hebrew = "he"
//        case italian = "it"
//        case dutch = "nl"
//        case norwegian = "no"
//        case portuguese = "pt"
//        case russian = "ru"
//        case swedish = "sv"
//        case undefined = "ud"
//        case chinese = "zh"
//    }
//
//    enum SortByDTO: String, Encodable, CaseIterable {
//        case relevancy, popularity, publishedAt
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case query = "q"
//        case sources, domains, excludeDomains, from, to
//        case language, sortBy, pageSize, page
//    }
//
//    let query: String
//    let sources: String?
//    let domains: String?
//    let excludeDomains: String?
//    let from: String?
//    let to: String?
//    var language: [LanguageDTO] = LanguageDTO.allCases
//    var sortBy: SortByDTO = .publishedAt
//    var pageSize: Int = 100
//    var page: Int = 1
//}
//
//extension NewsQueryRequestDTO {
//    init(query: String,
//         sources: String? = nil,
//         domains: String? = nil,
//         excludeDomains: String? = nil,
//         from: String? = nil,
//         to: String? = nil
//    ) {
//        self.query = query
//        self.sources = sources
//        self.domains = domains
//        self.excludeDomains = excludeDomains
//        self.from = from
//        self.to = to
//    }
//}


