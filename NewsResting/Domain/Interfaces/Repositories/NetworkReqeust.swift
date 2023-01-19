//
//  NetworkReqeust.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    
    func decode(_ data: Data) -> ModelType?
    func excute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
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
