//
//  DetailSearchRequestValue.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/22.
//

import Foundation

class DetailSearchRequestValue: Encodable {
    var fromDate: Date?
    var toDate:  Date?
    var mustIncludeSearchTerm: String?
    var excludeSearchTerm: String?
    
    func queryParameters(in dict: [String: String]) -> Dictionary<String, String> {
        var completedDict = dict
        // 여러개의 프로퍼티를 옵셔널 언랩핑하는 방법은 무엇일까?
        if let fromDate, let toDate {
            completedDict["from"] = dateFormmater.string(from: fromDate)
            completedDict["to"] = dateFormmater.string(from: toDate)
        } else if let fromDate {
            completedDict["from"] = dateFormmater.string(from: fromDate)
        }
        if let mustIncludeSearchTerm {
            completedDict["q"] = (completedDict["q"] ?? "") + "+\(mustIncludeSearchTerm)"
        }
        if let excludeSearchTerm {
            completedDict["q"] = (completedDict["q"] ?? "") + "-\(excludeSearchTerm)"
        }
        return completedDict
    }
}

fileprivate var dateFormmater: DateFormatter = {
    var formmator = DateFormatter()
    formmator.dateFormat = "yyyy-MM-dd"
    return formmator
}()
