//
//  ReviewRepository.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/28.
//

import CoreData
import Foundation

protocol ReviewRepository {
    func save(_ review: Review) async throws
    func fetch(_ id: Int, _ media: Media) async throws -> Review?
    func fetch(offset: Int, count: Int) async throws -> [Review]
    func update(_ review: Review) async throws
    func delete(_ review: Review) async throws
}

struct DefaultReviewRepository: ReviewRepository {
    
    // MARK: Properties
    
    private let dataSource: CoreDataStorage
    
    
    // MARK: Initializing
    
    init(dataSource: CoreDataStorage = .shared) {
        self.dataSource = dataSource
    }
    
    
    // MARK: Methods
    
    func save(_ review: Review) async throws {
        try await dataSource.save { context in
            _ = review.toEntity(in: context)
        }
    }
    
    func fetch(_ id: Int, _ media: Media) async throws -> Review? {
        let request = ReviewEntity.fetchRequest()
        let predicate1 = NSPredicate(format: "id = %d", id)
        let predicate2 = NSPredicate(format: "media = %@", media.rawValue)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        let result = try await dataSource.fetch(request)
        return result.first?.toDomain()
    }
    
    func fetch(offset: Int, count: Int) async throws -> [Review] {
        let request = ReviewEntity.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = count
        
        return try await dataSource.fetch(request).map { $0.toDomain() }
    }
    
    func update(_ review: Review) async throws {
        let request = ReviewEntity.fetchRequest()
        let predicate1 = NSPredicate(format: "id = %d", review.id)
        let predicate2 = NSPredicate(format: "media = %@", review.media.rawValue)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        try await dataSource.update(request) { entity in
            entity.title = review.title
            entity.content = review.content
        }
    }
    
    func delete(_ review: Review) async throws {
        let request = ReviewEntity.fetchRequest()
        let predicate1 = NSPredicate(format: "id = %d", review.id)
        let predicate2 = NSPredicate(format: "media = %@", review.media.rawValue)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        try await dataSource.delete(request)
    }
    
}
