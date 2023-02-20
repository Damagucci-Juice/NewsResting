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
        Task {
            filteredQueries = try await fetchRecentQueriesUseCase.fetch(with: text).map { query, list in
                return (query, list.toViewModel())
            }
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
    
    // TODO: - 먼가 판단로직, 수정로직, 여러개를 하는 듯한 느낌이 남.. 분리가능 할 듯
    func append(query: NewsQuery, newsListViewModel: NewsListViewModel) {
        let isContain = queriesAndViewModel.contains { (existQuery, _) in
            existQuery == query
        }
        guard isContain == false else {
            //MARK: - 가지고 있는 경우에 가장 위로 올림
            for i in 0..<queriesAndViewModel.count {
                let existQuery = queriesAndViewModel[i].0
                if existQuery == query {
                    let removed = queriesAndViewModel.remove(at: i)
                    queriesAndViewModel.insert(removed, at: 0)
                    return
                }
            }
            return
            
        }
        //MARK: - 기존에 겹치지 않으면 추가
        var reversedQueries = queriesAndViewModel.reversed() as [(NewsQuery, NewsListViewModel)]
        reversedQueries.append((query, newsListViewModel))
        queriesAndViewModel = reversedQueries.reversed()  as [(NewsQuery, NewsListViewModel)]
    }
    
    func cellTapped(_ offset: Int, isFiltered: Bool = false) {
        let (query, viewModel) = isFiltered ? filteredQueries[offset] : queriesAndViewModel[offset]
        onSearchTermTapped(query, viewModel)
    }
}
