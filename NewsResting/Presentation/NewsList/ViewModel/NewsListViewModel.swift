//
//  NewsListViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

final class NewsListViewModel {
    private(set) var totalResults: Int
    var newsViewModel: [NewsItemViewModel] = []

    var count: Int {
        newsViewModel.count
    }
    
    init(newsList: NewsList) {
        self.totalResults = newsList.totalResults
        newsViewModel = newsList.articles.map { $0.toViewModel() }
    }
}

extension NewsListViewModel {
    subscript(_ index: Int) -> NewsItemViewModel {
        newsViewModel[index]
    }

    var cellHeight: CGFloat {
        return 85
    }
}
