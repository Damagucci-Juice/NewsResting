//
//  CategoriesViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import Foundation

final class CategoriesViewModel {
    let useCase: FetchCategoriesUseCase
    private var categories: [NewsCategory: NewsList] = [:]
    
    init(useCase: FetchCategoriesUseCase) {
        self.useCase = useCase
        Task {
            try await initCategoriesVM()
        }
    }
}

extension CategoriesViewModel {
    subscript(_ category: NewsCategory) -> NewsList {
        return categories[category] ?? NewsList(totalResults: 0, articles: [])
    }
    
    func initCategoriesVM() async throws {
        do {
            self.categories = try await useCase.excute()
        } catch {
            throw NetworkError.fetchCategoriesFailure
        }
    }
}
