//
//  NewsQueryStorage.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/31.
//

import Foundation

protocol NewsQueryStorage {
    func fetchRecentQuries(maxCount: Int, completion: @escaping ([(NewsQuery, NewsList)]?) -> Void)
    /// 현재는 Save만 하고, QueryViewModel(가칭)에서 반응할 때마다 최근 쿼리를 불러오는 방향으로 설정
    //MARK: 이 메서드가 쿼리 뷰모델에서 바로 추가하는 로직을 사용할지, 아니면 뷰모델 클릭할 때마다 fetchRecentQueries 불러올지 고민
    func saveQuery(_ query: NewsQuery, newsList: NewsList, completion: @escaping ((NewsQuery, NewsList)?) -> Void)
}
