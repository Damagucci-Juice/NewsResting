//
//  NewsRepositoryImpl.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

final class NewsRepositoryImpl: NewsRepository {
    public func fetchNewsList(query: NewsQuery, completion: @escaping (Result<NewsList, Error>) -> Void) {
        let requestDTO = NewsQueryRequestDTO(query: query.query)
        var urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/everything?q=\(requestDTO.query)&apiKey=0c4d4b75321642f78aa273d2c23d021c")!)
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

extension Data {
    var prettyPrintedJSONString: NSString? { 
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
