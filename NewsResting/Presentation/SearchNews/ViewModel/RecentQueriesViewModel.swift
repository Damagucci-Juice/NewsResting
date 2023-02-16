//
//  SearchViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import Foundation

final class RecentQueriesViewModel {
    private let fetchRecentQueriesUseCase: FetchRecentQueriesUseCase
    private(set) var queries: [NewsQuery] = [] {
        didSet {
            onQueriesUpdated()
        }
    }
    private(set) var filteredQueries: [NewsQuery] = [] {
        didSet {
            onFilterUpdated()
        }
    }
    
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
            queries = try await fetchRecentQueriesUseCase.excute()
        } catch {
            throw NetworkError.fetchQuriesFailure
        }
    }
    
    func filterQuries(_ text: String)  {
        filteredQueries = queries.filter {
            $0.query.contains(text)
        }
    }
    
    func bindingFilter(completion: @escaping () -> Void) {
        onFilterUpdated = completion
    }
    
    func bindingQueries(completion: @escaping () -> Void) {
        onQueriesUpdated = completion
    }
    
    func append(query: NewsQuery, newsListViewModel: NewsListViewModel) {
        var reversedQueries = queries.reversed() as [NewsQuery]
        reversedQueries.append(query)
        queries = reversedQueries.reversed() as [NewsQuery]
    }
}
