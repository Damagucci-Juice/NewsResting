//
//  NewsListResource.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

struct QueryResource {
    let newsQueryRequestDTO: NewsQueryDTO
}

extension QueryResource: APIResource {
    
    typealias ModelType = NewsList
    
    var baseURL: String {
        "https://newsapi.org/v2/"
    }

    var path: String {
        "everything"
    }

    var query: [String : String] {
        newsQueryRequestDTO.queryParameters()
    }

    var header: [String : String] {
        ["X-Api-Key": "0c4d4b75321642f78aa273d2c23d021c"]
    }

    var method: HTTPMethod {
        .get
    }
}
