//
//  String+extension.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/11.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func makeKoreanEncoded() -> String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
