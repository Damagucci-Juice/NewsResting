//
//  NewsCategory.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/30.
//

import Foundation

enum NewsCategory: Int, Hashable, CaseIterable {
    case business = 0
    case entertainment,  general, health, science, sports, technology
    
    var text: String {
        String(describing: self)
    }
}
