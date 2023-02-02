//
//  NewsViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

struct NewsViewModel {
    let news: News
}

extension NewsViewModel {
    var id: String { news.id ?? "" }
    
    var pressName: String { news.source.name ?? "" }

    var author: String { news.authour ?? "" }
    
    var title: String { news.title ?? "" }
    
    var subHeadLine: String { news.description ?? ""}

    var imagePath: String? { news.urlToImage }

    var publishedDate: Date {
        dateFormatter.date(from: news.publishedAt) ?? Date()
    }
    
    var content: String { news.content ?? "" }

    var originNewsPath: String { news.url ?? "" }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
