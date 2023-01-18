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
    
    var pressName: String { news.source?.name ?? "" }
    
    var author: String { news.authour }
    
    var title: String { news.title }
    
    var subHeadLine: String { news.subHeadline }
    
    var imagePath: String? { news.imageUrl }
    
    var publishedDate: Date { news.publishedDate }
    
    var content: String { news.content }
    
    var originNewsPath: String { news.originNewsPath }
}
