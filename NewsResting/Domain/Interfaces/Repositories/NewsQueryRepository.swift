//
//  NewsQueryRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

protocol NewsQueryRepository {
    //TODO: Result 타입으로 변경, Error 케이스 추가, withContinuation으로 래핑할지 검토
    func fetchRecentQuery(maxCount: Int, completion: @escaping ([NewsQuery]?) -> Void)
    func saveQuery(query: NewsQuery)
}
