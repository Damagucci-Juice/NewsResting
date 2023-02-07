//
//  EntityConvertable.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation
import CoreData

protocol EntityConvertable {
    associatedtype EntityModel
    
    func toEntity(insertInto context: NSManagedObjectContext) -> EntityModel
}
