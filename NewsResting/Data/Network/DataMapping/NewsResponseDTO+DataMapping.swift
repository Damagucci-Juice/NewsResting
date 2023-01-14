//
//  NewsResponseDTO.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

struct NewsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case status, articles
        case totalNewsCount = "totalResults"
    }
    
    let status: String
    let articles: [NewsDTO]
    let totalNewsCount: Int
}

extension NewsResponseDTO {
    struct NewsDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case source
            case authour, title
            case subHeadline = "description"
            case publishedDate = "publishedAt"
            case imageUrl = "urlToImage"
            case newsLink = "url"
            case content
        }
        
        let source: Source
        let authour: String
        let title: String
        let subHeadline: String
        let newsLink: String
        let imageUrl: String?
        let publishedDate: String
        let content: String
    }
}

extension NewsResponseDTO.NewsDTO {
    struct Source: Decodable {
        let id: String?
        let name: String
    }
}
