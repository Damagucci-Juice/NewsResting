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
    private var categories: [NewsCategory: NewsListViewModel] = [:]
    
    private(set) var currentSectionItems: NewsListViewModel?
    private(set) var currentSection: NewsCategory?
    
    private var onSectionUpdated: () -> Void = { }
    
    var count: Int {
        currentSectionItems?.newsViewModel.count ?? 0
    }
    
    init(useCase: FetchCategoriesUseCase) {
        self.useCase = useCase
        Task {
            try await start()
        }
    }
}

extension CategoriesViewModel {
    subscript(_ offset: Int) -> NewsItemViewModel? {
        currentSectionItems?.newsViewModel[offset]
    }
    
    func start() async throws {
        do {
            let categoryDict = try await useCase.excute()
            for (category, newsList) in categoryDict {
                categories[category] = newsList.toViewModel()
            }
            setSection(category: .business)
            onSectionUpdated()
        } catch {
            throw NetworkError.fetchCategoriesFailure
        }
    }
    
    //MARK: - Input
    func setSection(category: NewsCategory) {
        guard let selectedNewsListViewModel = categories[category] else { return }
        currentSectionItems = selectedNewsListViewModel
        currentSection = category
        onSectionUpdated()
    }
        onSectionUpdated()
    }
    
    //MARK: - Output
    func binding(completion: @escaping () -> Void) {
        onSectionUpdated = completion
    }
}
