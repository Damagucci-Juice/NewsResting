//
//  NewsListViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

final class NewsListViewModel {
    var newsViewModel: [NewsItemViewModel] = []

    init(newsList: NewsList) {
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
