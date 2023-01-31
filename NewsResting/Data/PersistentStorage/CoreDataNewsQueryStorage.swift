//
//  CoreDataNewsQueryStorage.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/31.
//

import Foundation
import CoreData

final class CoreDataNewsQueryStorage {
    private var maxStorageLimit: Int
    private let coreDataStorage: CoreDataStorage
    
    init(maxStorageLimit: Int = 3, coreDataStorage: CoreDataStorage = .shared) {
        self.maxStorageLimit = maxStorageLimit
        self.coreDataStorage = coreDataStorage
    }
}

// MARK: Public
extension CoreDataNewsQueryStorage: NewsQueryStorage {
    //TODO: - 결과 타입 Result로 리펙터링
    func fetchRecentQuries(maxCount: Int, completion: @escaping ([NewsQuery]?) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = NewsQueryEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(NewsQueryEntity.createdAt),
                                                            ascending: false)]
                request.fetchLimit = maxCount
                let result = try context.fetch(request).map { $0.toDomain() }
                completion(result)
            } catch {
                completion(nil)
            }
        }
    }
    
    func saveQuery(_ query: NewsQuery, completion: @escaping (NewsQuery?) -> Void) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                try self.cleanUpQueries(for: query, inContext: context)
                let entity = NewsQueryEntity(newsQuery: query, insertInto: context)
                try context.save()
                completion(entity.toDomain())
            } catch {
                completion(nil)
            }
        }
    }
}

//MARK: Private
extension CoreDataNewsQueryStorage {
    private func cleanUpQueries(for query: NewsQuery, inContext context: NSManagedObjectContext) throws {
        let request: NSFetchRequest = NewsQueryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(NewsQueryEntity.createdAt),
                                                    ascending: false)]
        var result = try context.fetch(request)
        removeDuplicates(for: query, in: &result, inContext: context)
        removeQueries(limit: maxStorageLimit - 1, in: result, inContext: context)
    }
    
    private func removeDuplicates(for query: NewsQuery,
                                  in queries: inout [NewsQueryEntity],
                                  inContext context: NSManagedObjectContext) {
        queries
            .filter { $0.query == query.query }
            .forEach { context.delete($0) }
        queries.removeAll { $0.query == query.query }
    }
    
    private func removeQueries(limit: Int, in queries: [NewsQueryEntity], inContext context: NSManagedObjectContext) {
        guard queries.count > limit else { return }
        queries
            .suffix(queries.count - limit)
            .forEach { context.delete($0) }
    }
}
