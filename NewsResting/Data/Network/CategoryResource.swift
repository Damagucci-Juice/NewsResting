//
//  CategoryResource.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/08.
//

import Foundation

struct NewsCategoryDTO: Encodable {
    let category: String
}

struct CategoryResource {
    let newsCategoryDTO: NewsCategoryDTO

    static let defaultCountry = "kr"
}

extension CategoryResource: APIResource {
    typealias ModelType = NewsList
    
    var baseURL: String {
        "https://newsapi.org/v2/"
    }
    
    var path: String {
        "top-headlines"
    }
    
    var query: [String : String] {
        [
            "country": CategoryResource.defaultCountry,
            "category": newsCategoryDTO.category
        ]
    }
    
    var header: [String : String] {
        ["X-Api-Key": "0c4d4b75321642f78aa273d2c23d021c"]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    
}
