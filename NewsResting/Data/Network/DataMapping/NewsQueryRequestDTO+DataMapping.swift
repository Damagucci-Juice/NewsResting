//
//  NewsQueryRequestDTO+DataMapping.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

struct NewsQueryRequestDTO: Encodable {
    enum LanguageDTO: String, CaseIterable, Encodable {
        case arabic = "ar"
        case german = "de"
        case english = "en"
        case spanish = "es"
        case french = "fr"
        case hebrew = "he"
        case italian = "it"
        case dutch = "nl"
        case norwegian = "no"
        case portuguese = "pt"
        case russian = "ru"
        case swedish = "sv"
        case undefined = "ud"
        case chinese = "zh"
    }
    
    enum SortByDTO: String, Encodable, CaseIterable {
        case relevancy, popularity, publishedAt
    }
    
    private enum CodingKeys: String, CodingKey {
        case query = "q"
        case sources, domains, excludeDomains, from, to
        case language, sortBy, pageSize, page
    }
    
    let query: String?
    let sources: String?
    let domains: String?
    let excludeDomains: String?
    let from: String?
    let to: String?
    var language: [LanguageDTO] = LanguageDTO.allCases
    var sortBy: SortByDTO = .publishedAt
    var pageSize: Int = 100
    var page: Int = 1
}
