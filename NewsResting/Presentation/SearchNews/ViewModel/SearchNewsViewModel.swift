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
    func getNews(_ searchWord: String) async throws -> NewsListViewModel {
        let newsQuery = NewsQuery(query: searchWord)
        let newsList = try await usecase.excute(query: newsQuery)
        return NewsListViewModel(newsList: newsList)
    }
}
