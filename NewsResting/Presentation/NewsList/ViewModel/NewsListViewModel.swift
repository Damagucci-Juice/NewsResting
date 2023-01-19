//
//  NewsListViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

final class NewsListViewModel {
    var newsViewModel: [NewsViewModel] = []
    
    let newsRepository: NewsRepository
    
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
        do {
            try newsRepository.fetchNewsList(query: newsQuery) { [unowned self] result in
                switch result {
                case .success(let newsList):
                    self.newsViewModel = newsList.articles.map {
                        NewsViewModel(news: $0)
                    }
                    self.onUpdated()
                case .failure(let error):
                    debugPrint(error)
                }
            }
        } catch {
            debugPrint(NetworkError.urlGeneration.localizedDescription)
        }
    }
    
    var cellHeight: CGFloat {
        return 85
    }
}

enum NetworkError: Error {
    case urlGeneration
}
