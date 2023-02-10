//
//  NewsListViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

final class NewsListViewModel {
    var newsViewModel: [NewsItemViewModel] = []
    
    //TODO: - 여기 UseCase 도입하면서 완전히 바뀜 1
    private var newsRepository: NewsRepository
    private var onUpdated: () -> Void = { }
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
}

extension NewsListViewModel {
    subscript(_ index: Int) -> NewsItemViewModel {
        newsViewModel[index]
    }
    
    public func bind(_ completion: @escaping () -> Void) {
        self.onUpdated = completion
    }
    
    //TODO: - 여기 UseCase 도입하면서 완전히 바뀜 2
//    public func fetchNews(_ search: String) {
//        let newsQuery = NewsQuery(query: search)
//        newsRepository.fetchNews(with: newsQuery) { [unowned self] result in
//            guard let newsList = result?.articles else { return }
//            newsViewModel = newsList.map { $0.toViewModel() }
//            onUpdated()
//        }
//    }
//
//    public func fetchNews(with category: NewsCategory) {
//        newsRepository.fetchNews(by: category) { [unowned self] result in
//            guard let newsList = result?.articles else { return }
//            newsViewModel = newsList.map { $0.toViewModel() }
//            onUpdated()
//        }
//    }
    
    var cellHeight: CGFloat {
        return 85
    }
}
