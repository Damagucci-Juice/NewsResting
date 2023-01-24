//
//  NewsListResource.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

struct NewsListResource {
    var searchKey: String?
    
    init(searchKey: String? = nil) {
        self.searchKey = searchKey
    }
}

extension NewsListResource: APIResource {
    
    typealias ModelType = NewsList

    var baseURL: String {
        "https://newsapi.org/v2/"
    }

    var path: String {
        "everything?"
    }

    var query: [String : String] {
        return searchKey != nil ? ["q" : searchKey ?? ""] : [:]
    }

    var header: [String : String] {
        return ["X-Api-Key": "0c4d4b75321642f78aa273d2c23d021c"]
    }

    var method: HTTPMethod {
        .get
    }
}
