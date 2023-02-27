//
//  DetailSearchRequestValue.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/22.
//

import Foundation

class DetailSearchRequestValue: Encodable {
    var fromDateCompo: DateComponents?
    var toDateCompo:  DateComponents? = nil
    var includeSearchTerms: [String] = []
    var excludeSearchTerms: [String] = []
    
    func queryParameters(in dict: [String: String]) -> Dictionary<String, String> {
        var completedDict = dict
        // 여러개의 프로퍼티를 옵셔널 언랩핑하는 방법은 무엇일까?
        if let fromDate = fromDateCompo?.date, let toDate = toDateCompo?.date {
            completedDict["from"] = dateFormmater.string(from: fromDate)
            completedDict["to"] = dateFormmater.string(from: toDate)
        } else if let fromDate = fromDateCompo?.date {
            completedDict["from"] = dateFormmater.string(from: fromDate)
        }
        if !includeSearchTerms.isEmpty {
            completedDict["q"]? += "+\(includeSearchTerms.joined(separator: "+"))"
        }
        if !excludeSearchTerms.isEmpty {
            completedDict["q"]? += "-\(excludeSearchTerms.joined(separator: "-"))"
        }
        return completedDict
    }
}

fileprivate var dateFormmater: DateFormatter = {
    var formmator = DateFormatter()
    formmator.dateFormat = "yyyy-MM-dd"
    return formmator
}()
