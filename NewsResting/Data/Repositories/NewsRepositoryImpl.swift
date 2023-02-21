//
//  NewsRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

final class NewsRepositoryImpl {
    private var queryReqeust: APIRequest<QueryResource>?
    private var categoryRequest: APIRequest<CategoryResource>?
    private var responseCache: NewsResponseStorage
    
    init(responseCache: NewsResponseStorage) {
        self.responseCache = responseCache
    }
}

//MARK: - Public
extension NewsRepositoryImpl: NewsRepository {
    
    func fetchNews(by category: NewsCategory, page: Int) async throws -> NewsList {
        let categoryRequestDTO = NewsCategoryDTO(category: category.text, page: page)
        
        if let cached = try? await responseCache.getCategoryResponse(categoryRequestDTO) {
            return cached
        }
        
        let categoryResource = CategoryResource(newsCategoryDTO: categoryRequestDTO)
        categoryRequest = makeCategoryAPIRequest(categoryResource)
        guard let newsList = try? await categoryRequest?.excute()
        else { throw NetworkError.categoryFetchFailure(category) }
        responseCache.save(categoryDTO: categoryRequestDTO, response: newsList)
        return newsList
    }
    
    //TODO: - 두 펑션이 파라미터만 차이가 있지 사실상 하는일은 동일하여 중복되고 있음, 개선 방안이 있을까?
    //MARK: 쿼리를 이용해 뉴스 페치
    func fetchNews(with query: NewsQuery, page: Int) async throws -> NewsList {
        let queryRequestDTO = NewsQueryDTO(query: query.query, page: page)
        
        if let cached = try? await responseCache.getSearchResponse(queryRequestDTO) {
            return cached
        }
        
        let queryResource = QueryResource.init(newsQueryRequestDTO: queryRequestDTO)
        queryReqeust = makeSearchAPIRequest(queryResource)
        guard let newsList = try? await queryReqeust?.excute()
        else { throw NetworkError.searchFetchFailure(query) }
        responseCache.save(queryDTO: queryRequestDTO, response: newsList)
        return newsList
    }

}

//MARK: - Private
extension NewsRepositoryImpl {
    //TODO: 나라별, 언론사별 Top HeadLine이 추가될 것인데, 그 때마다 make 함수가 추가될 것인가?
    private func makeSearchAPIRequest(_ resource: QueryResource) -> APIRequest<QueryResource> {
        return APIRequest(resource: resource)
    }
    
    private func makeCategoryAPIRequest(_ resource: CategoryResource) -> APIRequest<CategoryResource> {
        return APIRequest(resource: resource)
    }
}

