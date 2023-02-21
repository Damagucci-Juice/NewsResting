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
    private(set) var pageOfSection: [NewsCategory: Int] = [:]
    
    private var onSectionUpdated: () -> Void = { }
    
    var count: Int {
        currentSectionItems?.newsViewModel.count ?? 0
    }
    
    init(useCase: FetchCategoriesUseCase) {
        self.useCase = useCase
        NewsCategory.allCases.forEach { cateogry in
            pageOfSection[cateogry] = 1
        }
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
    
    func loadNextNews() async throws {
        guard let category = currentSection,
              let currentPage = pageOfSection[category]
        else { return }
            
        let nextNewsList = try await useCase.getNextNews(category, page: currentPage + 1)
        pageOfSection[category]? += 1
        
        append(nextNews: nextNewsList, at: category)
        onSectionUpdated()
    }
    
    //MARK: - Output
    func binding(completion: @escaping () -> Void) {
        onSectionUpdated = completion
    }
}


//MARK: - Private
extension CategoriesViewModel {
    private func append(nextNews: NewsList, at category: NewsCategory) {
        guard let existNewsListViewModel = categories[category] else { return }
        let additionalNewsItemViewModels = nextNews.toViewModel().newsViewModel
        let added = existNewsListViewModel.newsViewModel + additionalNewsItemViewModels
        categories[category]?.newsViewModel = added
    }
}
