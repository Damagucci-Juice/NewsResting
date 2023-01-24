//
//  Press.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import Foundation

// MARK: - Press Id, Press Name (언론사)
struct Press: Decodable, Equatable, Identifiable  {
    let id: String?
    let name: String?
}
