//
//  NewsRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

final class NewsRepositoryImpl: NewsRepository {
    public func fetchNewsList(query: NewsQuery, completion: @escaping (Result<NewsList, Error>) -> Void) throws {
        let requestDTO = NewsQueryRequestDTO(query: query.query)
        let resource = NewsListResource(searchKey: requestDTO.query)
        let urlRequest = try resource.urlRequest()
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let decoder = JSONDecoder()
            guard let data = data else { return }
            if let newsList = try? decoder.decode(NewsResponseDTO.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(newsList.toDomain()))
                }
            }
        }
        task.resume()
    }
}
