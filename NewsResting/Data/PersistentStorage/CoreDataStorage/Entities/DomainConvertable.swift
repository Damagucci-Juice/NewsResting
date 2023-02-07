//
//  DomainConvertable.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation

protocol DomainConvertable {
    associatedtype DomainModel
    
    func toDomain() -> DomainModel
}
