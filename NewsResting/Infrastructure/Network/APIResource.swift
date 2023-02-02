//
//  APIResource.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

protocol APIResource {
    associatedtype ModelType: Decodable
    var baseURL: String { get }
    var path: String { get }
    var query: [String: String] { get }
    var header: [String: String] { get }
    var method: HTTPMethod { get }
}

extension APIResource {
    public func url() throws -> URL {
        let baseURL = self.baseURL.last != "/" ? self.baseURL + "/" : self.baseURL
        let absolutePath = self.path.last != "&" ? self.path + "&" : self.path
        let endpoint = path.isEmpty ? baseURL : baseURL.appending(absolutePath)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        query.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    public func urlRequest() throws -> URLRequest {
        let url = try self.url()
        var urlRequest = URLRequest(url: url)
        
        self.header.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
