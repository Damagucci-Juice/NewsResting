//
//  NewsQueryRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

protocol NewsQueryRepository {
    //TODO: Result 타입으로 변경, Error 케이스 추가
    //TODO: withContinuation으로 랩핑된 것이랑 completion 버전 메서드랑 혼용해도 되는가에 대한 문제
    func fetchRecentQuery(maxCount: Int, completion: @escaping ([NewsQuery]?) -> Void)
    func fetchRecentQuery(maxCount: Int) async throws -> [NewsQuery]
    func saveQuery(query: NewsQuery, completion: @escaping (NewsQuery?) -> Void)
    @discardableResult
    func saveQuery(query: NewsQuery) async throws -> NewsQuery
}
