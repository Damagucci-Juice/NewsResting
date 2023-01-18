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
            case originNewsPath = "url"
            case content
        }
        
        let source: SourceDTO?
        let authour: String?
        let title: String?
        let subHeadline: String?
        let originNewsPath: String?
        let imageUrl: String?
        let publishedDate: String?
        let content: String?
    }
}

extension NewsResponseDTO.NewsDTO {
    struct SourceDTO: Decodable {
        let id: String?
        let name: String?
    }
}

extension NewsResponseDTO {
    func toDomain() -> NewsList {
        return NewsList(totalNewsCount: self.totalNewsCount,
                        articles: articles.map { $0.toDomain() })
    }
}

extension NewsResponseDTO.NewsDTO {
    func toDomain() -> News {
        return News(source: self.source?.toDomain(), authour: self.authour, title: self.title, subHeadline: self.subHeadline, imageUrl: self.imageUrl, publishedDate: dateFormatter.date(from: self.publishedDate ?? ""), content: self.content, originNewsPath: self.originNewsPath)
    }
}

extension NewsResponseDTO.NewsDTO.SourceDTO {
    func toDomain() -> Source? {
        return Source(id: self.id,
                      name: self.name)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
