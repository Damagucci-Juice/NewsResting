//
//  SearchNewsViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import Foundation

final class SearchNewsViewModel {
    private let usecase: SearchNewsUseCase
    
    init(usecase: SearchNewsUseCase) {
        self.usecase = usecase
    }
}

extension SearchNewsViewModel {
    func fetchNewsListViewModel(_ searchWord: String, page: Int) async throws -> (NewsQuery, NewsListViewModel) {
        let newsQuery = NewsQuery(query: searchWord)
        let newsList = try await usecase.excute(query: newsQuery, page: page)
        return (newsQuery, NewsListViewModel(newsList: newsList))
    }
}
