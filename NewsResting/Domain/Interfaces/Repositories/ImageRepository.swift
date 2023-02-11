//
//  ImageRepository.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/11.
//

import Foundation

protocol ImageRepository {
    func fetchImage(path: String) async throws -> Data 
}
