//
//  CategoriesViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import Foundation

final class CategoriesViewModel {
    static let cellHeight: CGFloat = 40
    let useCase: FetchCategoriesUseCase
    private var categories: [NewsCategory: NewsList] = [:]
    
    init(useCase: FetchCategoriesUseCase) {
        self.useCase = useCase
        Task {
            try await start()
        }
    }
}

extension CategoriesViewModel {
    subscript(_ index: Int) -> NewsList {
        let category: NewsCategory = .init(rawValue: index) ?? .business
        return categories[category] ?? NewsList(totalResults: 0, articles: [])
    }
    
    func start() async throws {
        do {
            self.categories = try await useCase.excute()
        } catch {
            throw NetworkError.fetchCategoriesFailure
        }
    }
}
