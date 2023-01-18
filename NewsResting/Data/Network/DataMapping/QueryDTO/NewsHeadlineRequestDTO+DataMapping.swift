//
//  NewsHeadlineRequestDTO+DataMapping.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

struct NewsHeadlineRequestDTO: Encodable {
    private enum CodingKeys: String, CodingKey {
        case query = "q"
        case country, category, sources, page, pageSize
    }
    
    enum CountryDTO: String, Encodable, CaseIterable {
        case unitedStatesOfAmerica = "us"
        case japan = "jp"
        case korea = "kr"
        case china = "cn"
    }
    
    enum CategoryDTO: String, Encodable {
        case business, entertainment, general, health, science, sports, technology
    }
    
    let country: CountryDTO?
    let category: CategoryDTO?
    let sources: String?
    let query: String?
    var page: Int = 1
    var pageSize: Int = 20 // max 100
}
