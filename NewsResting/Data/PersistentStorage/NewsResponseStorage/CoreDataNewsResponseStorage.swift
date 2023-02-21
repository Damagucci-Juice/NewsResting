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
    func save(queryDTO: NewsQueryDTO, response: NewsList) {
        coreDatastorage.performBackgroundTask { context in
            do {
                self.deleteResponse(queryDTO: queryDTO, in: context)
                let queryEntity = queryDTO.toEntity(insertInto: context)
                queryEntity.response = response.toEntity(insertInto: context)

                try context.save()
            } catch {
                debugPrint(CoreDataStorageError.saveError(error))
            }
        }
    }
    
    func save(categoryDTO: NewsCategoryDTO, response: NewsList) {
        coreDatastorage.performBackgroundTask { context in
            do {
                self.deleteResponse(categoryDTO: categoryDTO, in: context)
                let categoryEntity = categoryDTO.toEntity(insertInto: context)
                categoryEntity.response = response.toEntity(insertInto: context)

                try context.save()
            } catch {
                debugPrint(CoreDataStorageError.saveError(error))
            }
        }
    }
    
    func getSearchResponse(_ queryDTO: NewsQueryDTO) async throws -> NewsList {
        try await withCheckedThrowingContinuation { continuation in
            getResponse(queryDTO: queryDTO) { result in
                switch result {
                case .success(let newsList):
                    return continuation.resume(returning: newsList)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getCategoryResponse(_ categoryDTO: NewsCategoryDTO) async throws -> NewsList {
        try await withCheckedThrowingContinuation { continuation in
            getResponse(categoryDTO: categoryDTO) { result in
                switch result {
                case .success(let newsList):
                    return continuation.resume(returning: newsList)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
}


//MARK: - Private
extension CoreDataNewsResponseStorage {
    
    private func getResponse(queryDTO: NewsQueryDTO, completion: @escaping (Result<NewsList, CoreDataStorageError>) -> Void) {
        coreDatastorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(queryDTO: queryDTO)
                let requset = try context.fetch(fetchRequest).first
                guard let newsList = requset?.response?.toDomain() else {
                    completion(.failure(.returnedNil))
                    return
                }
                completion(.success(newsList))
            } catch {
                completion(.failure(.readError(error)))

            }
        }
    }
    
    private func getResponse(categoryDTO: NewsCategoryDTO, completion: @escaping (Result<NewsList, CoreDataStorageError>) -> Void) {
        coreDatastorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(categoryDTO: categoryDTO)
                let requset = try context.fetch(fetchRequest).first
                guard let newsList = requset?.response?.toDomain() else {
                    completion(.failure(.returnedNil))
                    return
                }
                completion(.success(newsList))
            } catch {
                completion(.failure(.readError(error)))

            }
        }
    }
    

    private func deleteResponse(queryDTO: NewsQueryDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(queryDTO: queryDTO)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    private func deleteResponse(categoryDTO: NewsCategoryDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(categoryDTO: categoryDTO)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    private func fetchRequest(queryDTO: NewsQueryDTO) -> NSFetchRequest<NewsQueryEntity> {
        let request = NewsQueryEntity.fetchRequest()
        let tenMinutesAgo = Date().addingTimeInterval(-600)
        request.predicate = NSPredicate(format: "%K = %@ AND %K <= %@",
                                        #keyPath(NewsQueryEntity.query), queryDTO.query,
                                        #keyPath(NewsQueryEntity.createdAt), tenMinutesAgo as NSDate
        )
        return request
    }
    
    private func fetchRequest(categoryDTO: NewsCategoryDTO) -> NSFetchRequest<NewsCategoryEntity> {
        let request = NewsCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %i" ,
                                        #keyPath(NewsCategoryEntity.category), categoryDTO.category,
                                        #keyPath(NewsCategoryEntity.page), categoryDTO.page
        )
        return request
    }
}
