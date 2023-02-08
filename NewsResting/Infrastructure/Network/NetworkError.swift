//
//  NetworkError.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/02.
//

import Foundation

enum NetworkError: Error {
    case urlGeneration
    case decodingFailure
    //TODO: - 이게 여기 있어도 되는 에러의 종류인걸까?
    case categoryFetchFailure(NewsCategory)
    case searchFetchFailure(NewsQuery)
    case fetchQuriesFailure
}
