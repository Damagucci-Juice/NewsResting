//
//  NewsListViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

protocol NewsListViewModelDelegate {
    func completedLoad()
}

final class NewsListViewModel {
    var newsViewModel: [NewsViewModel] = []
    
    let newsRepository: NewsRepository
    
    var delegate: NewsListViewModelDelegate?
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
    
}

extension NewsListViewModel {
    subscript(_ index: Int) -> NewsViewModel {
        newsViewModel[index]
    }
    
    func fetchNews(_ search: String) {
        let newsQuery = NewsQuery(query: search)
        newsRepository.fetchNewsList(query: newsQuery) { [unowned self] result in
            switch result {
            case .success(let newsList):
                self.newsViewModel = newsList.articles.map {
                    NewsViewModel(news: $0)
                }
                DispatchQueue.main.async {
                    self.delegate?.completedLoad()
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    var cellHeight: CGFloat {
        return 85
    }
}
