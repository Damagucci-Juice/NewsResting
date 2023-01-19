//
//  APIResource.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/19.
//

import Foundation

enum RequestGenerationError: Error {
    case components
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol APIResource {
    associatedtype ModelType
    var baseURL: String { get }
    var path: String { get }
    var query: [String: String] { get }
    var header: [String: String] { get }
    var method: HTTPMethod { get }
}

extension APIResource {
    public func url() throws -> URL {
        let baseURL = self.baseURL.last != "/" ? self.baseURL + "/" : self.baseURL
        let endpoint = path.isEmpty ? baseURL : baseURL.appending(path)
        
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
        
//        var allHeaders: [String: String] = [:]
//        self.header.forEach { allHeaders.updateValue($1, forKey: $0) }
//        urlRequest.allHTTPHeaderFields = allHeaders
        
        self.header.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
