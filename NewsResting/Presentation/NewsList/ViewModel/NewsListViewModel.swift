//
//  NewsListViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

final class NewsListViewModel {
    var newsViewModel: [NewsViewModel] = []
    
    private var newsRepository: NewsRepository
    private var onUpdated: () -> Void = { }
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
}

extension NewsListViewModel {
    subscript(_ index: Int) -> NewsViewModel {
        newsViewModel[index]
    }
    
    public func bind(_ completion: @escaping () -> Void) {
        self.onUpdated = completion
    }
    
    public func fetchNews(_ search: String) {
        let newsQuery = NewsQuery(query: search)
        newsRepository.fetchNews(with: newsQuery) { [weak self] result in
            guard let newsList = result?.articles else { return }
            self?.newsViewModel = newsList.map { NewsViewModel(news: $0)}
            self?.onUpdated()
        }
    }
    
    public func fetchNews(with category: String) {
        
    }
    
    var cellHeight: CGFloat {
        return 85
    }
}

enum NetworkError: Error {
    case urlGeneration
}
