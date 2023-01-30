//
//  NetworkRequestable.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

protocol NetworkRequestable: AnyObject {
    associatedtype ModelType
    
    func decode(_ data: Data) -> ModelType?
    func excute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequestable {
    func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (ModelType?) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, _ in
            guard let data = data, let value = self?.decode(data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(value)
            }
        }
        task.resume()
    }
}
