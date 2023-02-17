//
//  SearchViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import Foundation

final class RecentQueriesViewModel {
    private let fetchRecentQueriesUseCase: FetchRecentQueriesUseCase
    private(set) var queriesAndViewModel: [(NewsQuery, NewsListViewModel)] = [] {
        didSet {
            onQueriesUpdated()
        }
    }
    private(set) var filteredQueries: [(NewsQuery, NewsListViewModel)] = [] {
        didSet {
            onFilterUpdated()
        }
    }
    
    private var onSearchTermTapped: (NewsQuery, NewsListViewModel) -> Void = { _, _  in }
    
    private var onQueriesUpdated: () -> Void = { }
    
    private var onFilterUpdated: () -> Void = { }
    
    init(fetchRecentQueriesUseCase: FetchRecentQueriesUseCase) {
        self.fetchRecentQueriesUseCase = fetchRecentQueriesUseCase
        Task {
            try await fetchQuereis()
        }
    }
}

extension RecentQueriesViewModel {
    private func fetchQuereis() async throws {
        do {
            queriesAndViewModel = try await fetchRecentQueriesUseCase.excute().map {
                return ($0.0, $0.1.toViewModel())
            }
        } catch {
            throw NetworkError.fetchQuriesFailure
        }
    }
    
    func filterQuries(_ text: String)  {
        filteredQueries = queriesAndViewModel.filter {
            $0.0.query.contains(text)
        }
    }
    
    func bindingFilter(completion: @escaping () -> Void) {
        onFilterUpdated = completion
    }
    
    func bindingQueries(completion: @escaping () -> Void) {
        onQueriesUpdated = completion
    }
    
    func bindingTapped(completion: @escaping (NewsQuery, NewsListViewModel) -> Void) {
        onSearchTermTapped = completion
    }
    
    func append(query: NewsQuery, newsListViewModel: NewsListViewModel) {
        var reversedQueries = queriesAndViewModel.reversed() as [(NewsQuery, NewsListViewModel)]
        reversedQueries.append((query, newsListViewModel))
        queriesAndViewModel = reversedQueries.reversed()  as [(NewsQuery, NewsListViewModel)]
    }
    
    func cellTapped(_ offset: Int, isFiltered: Bool = false) {
        let (query, viewModel) = isFiltered ? filteredQueries[offset] : queriesAndViewModel[offset]
        onSearchTermTapped(query, viewModel)
    }
}
