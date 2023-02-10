//
//  SearchViewModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/10.
//

import Foundation

final class RecentQueriesViewModel {
    private let fetchRecentQueriesUseCase: FetchRecentQueriesUseCase
    private(set) var queries: [NewsQuery] = []
    
    init(fetchRecentQueriesUseCase: FetchRecentQueriesUseCase) {
        self.fetchRecentQueriesUseCase = fetchRecentQueriesUseCase
        Task {
            try await fetchQuereis()
        }
    }
}

extension RecentQueriesViewModel {
    func fetchQuereis() async throws {
        do {
            queries = try await fetchRecentQueriesUseCase.excute()
        } catch {
            throw NetworkError.fetchQuriesFailure
        }
    }
}
