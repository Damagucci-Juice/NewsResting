//
//  FetchRecentQueriesUseCase.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/08.
//

import Foundation

protocol FetchRecentQueriesUseCase {
    func excute() async throws -> [NewsQuery]
}

final class FetchRecentQueriesUseCaseImpl {
    private var queryRepository: NewsQueryRepository
    private var maxCount = 5
    
    init(queryRepository: NewsQueryRepository) {
        self.queryRepository = queryRepository
    }
}

extension FetchRecentQueriesUseCaseImpl: FetchRecentQueriesUseCase {
    func excute() async throws -> [NewsQuery] {
        do {
            return try await queryRepository.fetchRecentQuery(maxCount: maxCount)
        } catch {
            throw NetworkError.fetchQuriesFailure
        }
    }
}
