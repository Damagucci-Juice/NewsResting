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
    
    //TODO: - 여기서 뷰 모델로 맵핑하는것이 맞는가? 아니면 UseCase에서 child ViewModel을 매핑하는게 맞는가?
    public func fetchNews(_ search: String) {
        let newsQuery = NewsQuery(query: search)
        newsRepository.fetchNews(with: newsQuery) { [unowned self] result in
            guard let newsList = result?.articles else { return }
            newsViewModel = newsList.map { $0.toViewModel() }
            onUpdated()
        }
    }
    
    public func fetchNews(with category: NewsCategory) {
        newsRepository.fetchNews(with: category) { [unowned self] result in
            guard let newsList = result?.articles else { return }
            newsViewModel = newsList.map { $0.toViewModel() }
            onUpdated()
        }
    }
    
    var cellHeight: CGFloat {
        return 85
    }
}
