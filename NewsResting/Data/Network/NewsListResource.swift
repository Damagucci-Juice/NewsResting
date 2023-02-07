//
//  NewsListResource.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

enum NewsListResource {
    case search(key: String)
    case category(NewsCategory)
}

extension NewsListResource: APIResource {
    
    typealias ModelType = NewsList

    // TODO: - UserDefault로 저장해서 할지, 아니면 나라별 탑 헤드라인을 서비스할 지 고민
    static let defaultCountry = "kr"
    
    var baseURL: String {
        "https://newsapi.org/v2/"
    }

    //TODO: - "?"를 path 뒤에 항상 처렇게 붙여줘야하는것인지, 아니면 URL Request만들 때 추가해줄 수 있는지 검토
    var path: String {
        switch self {
        case .search(_):
            return "everything?"
        case .category(_):
            return "top-headlines?"
        }
    }

    //TODO: - 키와 벨류 사이엔 "=", 키와 키 사이엔 "&"
    var query: [String : String] {
        switch self {
        case .search(let key):
            return ["q": key]
        case .category(let category):
            return [
                "country": NewsListResource.defaultCountry,
                "category": category.rawValue
            ]
        }
    }

    var header: [String : String] {
        return ["X-Api-Key": "0c4d4b75321642f78aa273d2c23d021c"]
    }

    var method: HTTPMethod {
        .get
    }
}
