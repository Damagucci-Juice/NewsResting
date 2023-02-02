//
//  NetworkRequestable.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

protocol NetworkRequestable: AnyObject {
    associatedtype ModelType
    
    func decode(_ data: Data) throws -> ModelType
    func excute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequestable {
    func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (ModelType?) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            do {
                let value = try self?.decode(data)
                DispatchQueue.main.async {
                    completion(value)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
