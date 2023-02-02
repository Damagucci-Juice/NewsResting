//
//  NewsRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

final class NewsRepositoryImpl {
    private var apiReqeust: APIRequest<NewsListResource>?
}

//MARK: - Public
extension NewsRepositoryImpl: NewsRepository {
    func fetchNews(by category: NewsCategory) async throws -> NewsList {
        try await withCheckedThrowingContinuation { [unowned self] continuation in
            fetchNews(by: category) { newsList in
                if let newsList = newsList {
                    return continuation.resume(returning: newsList)
                } else {
                    return continuation.resume(throwing: NetworkError.categoryFetchFailure(category))
                }
            }
        }
    }
    
    //TODO: - 두 펑션이 파라미터만 차이가 있지 사실상 하는일은 동일하여 중복되고 있음, 개선 방안이 있을까?
    //MARK: 쿼리를 이용해 뉴스 페치
    func fetchNews(with query: NewsQuery, completion: @escaping (NewsList?) -> Void) {
        let newsListResource = makeNewsListResource(query)
        self.apiReqeust = makeNewsAPIRequest(newsListResource)
        self.apiReqeust?.excute(withCompletion: completion)
    }
    //MARK: 카테고리를 이용해 뉴스 페치(분야별 뉴스)
    func fetchNews(by category: NewsCategory, completion: @escaping (NewsList?) -> Void) {
        let newsListResource = makeNewsListResourece(category)
        self.apiReqeust = makeNewsAPIRequest(newsListResource)
        self.apiReqeust?.excute(withCompletion: completion)
    }
}

//MARK: - Private
extension NewsRepositoryImpl {
    //TODO: 나라별, 언론사별 Top HeadLine이 추가될 것인데, 그 때마다 make 함수가 추가될 것인가?
    private func makeNewsListResource(_ query: NewsQuery) -> NewsListResource {
        return NewsListResource.search(key: query.query)
    }
    
    private func makeNewsListResourece(_ category: NewsCategory) -> NewsListResource {
        return NewsListResource.category(category)
    }
    
    private func makeNewsAPIRequest(_ resource: NewsListResource) -> APIRequest<NewsListResource> {
        return APIRequest(resource: resource)
    }
}
