//
//  News.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import Foundation

struct News: Equatable, Identifiable {
    var id: String? { self.source?.id }
    let source: Press?
    let authour: String
    let title: String
    let subHeadline: String
    let imageUrl: String?
    let publishedDate: Date
    let content: String
    let originNewsPath: String
}
