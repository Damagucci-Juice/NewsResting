//
//  NewsListViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

final class NewsListViewModel {
    var newsViewModel: [NewsViewModel] = []
    
    private var newsRepository: NewsRepositoryImpl<NewsListResource>?
    private var onUpdated: () -> Void = { }
}

extension NewsListViewModel {
    subscript(_ index: Int) -> NewsViewModel {
        newsViewModel[index]
    }
    
    public func bind(_ completion: @escaping () -> Void) {
        self.onUpdated = completion
    }
    
    public func fetchNews(_ search: String? = nil) {
        let newsListResource = NewsListResource(searchKey: search)
        let repository = NewsRepositoryImpl(resource: newsListResource)
        self.newsRepository = repository
        repository.excute { [weak self] newsList in
            guard let newsList = newsList?.articles else { return }
            self?.newsViewModel = newsList.map { NewsViewModel(news: $0) }
            self?.onUpdated()
        }
    }
    
    var cellHeight: CGFloat {
        return 85
    }
}

enum NetworkError: Error {
    case urlGeneration
}
