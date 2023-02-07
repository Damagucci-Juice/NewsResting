//
//  DomainModel.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation

protocol DomainModel {
    associatedtype DomainModelEntity
    
    func toDomain() -> DomainModelEntity
}
