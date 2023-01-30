//
//  NewsRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

final class NewsRepositoryImpl {
    private var apiReqeust: APIRequest<NewsListResource>?
    
    private func makeNewsListResource(_ query: NewsQuery) -> NewsListResource {
        return NewsListResource.search(key: query.query)
    }
    
    private func makeNewsAPIRequest(_ resource: NewsListResource) -> APIRequest<NewsListResource> {
        return APIRequest(resource: resource)
    }
}

extension NewsRepositoryImpl: NewsRepository {
    //MARK: 쿼리를 이용해 뉴스 페치
    func fetchNews(with query: NewsQuery, completion: @escaping (NewsList?) -> Void) {
        let newsListResource = makeNewsListResource(query)
        self.apiReqeust = makeNewsAPIRequest(newsListResource)
        self.apiReqeust?.excute(withCompletion: completion)
    }
    //MARK: 카테고리를 이용해 뉴스 페치(분야별 뉴스)
}
