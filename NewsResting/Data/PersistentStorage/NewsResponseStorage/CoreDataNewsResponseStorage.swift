//
//  CoreDataNewsResponseStorage.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/07.
//

import Foundation
import CoreData

final class CoreDataNewsResponseStorage {
    private var coreDatastorage: CoreDataStorage
    
    init(coreDatastorage: CoreDataStorage = .shared) {
        self.coreDatastorage = coreDatastorage
    }
}

//MARK: - Public
extension CoreDataNewsResponseStorage: NewsResponseStorage {

    func getResponse(query: NewsQuery, completion: @escaping (Result<NewsList?, CoreDataStorageError>) -> Void) {
        coreDatastorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(query: query)
                let requset = try context.fetch(fetchRequest).first
                
                completion(.success(requset?.response?.toDomain()))
            } catch {
                completion(.failure(.readError(error)))

            }
        }
    }
    
    func save(query: NewsQuery, response: NewsList) {
        coreDatastorage.performBackgroundTask { context in
            do {
                self.deleteResponse(query: query, in: context)
                let queryEntity = query.toEntity(insertInto: context)
                queryEntity.response = response.toEntity(insertInto: context)

                try context.save()
            } catch {
                debugPrint(CoreDataStorageError.saveError(error))
            }
        }
    }
}


//MARK: - Private
extension CoreDataNewsResponseStorage {
    private func deleteResponse(query: NewsQuery, in context: NSManagedObjectContext) {
        let request = fetchRequest(query: query)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    private func fetchRequest(query: NewsQuery) -> NSFetchRequest<NewsQueryEntity> {
        let request = NewsQueryEntity.fetchRequest()
        let tenMinutesAgo = Date().addingTimeInterval(-600)
        request.predicate = NSPredicate(format: "%K = %@ AND %K <= %@",
                                        #keyPath(NewsQueryEntity.query), query.query,
                                        #keyPath(NewsQueryEntity.createdAt), tenMinutesAgo as NSDate
        )
        return request
    }
}
