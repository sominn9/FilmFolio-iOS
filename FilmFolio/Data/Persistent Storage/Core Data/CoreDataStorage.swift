//
//  CoreDataStorage.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/28.
//

import CoreData
import Foundation

enum CoreDataStorageType {
    case sqlite
    case inMemory
}

final class CoreDataStorage {
    
    static let shared: CoreDataStorage = {
        return .init(name: "Model", storeType: .sqlite)
    }()
    
    init(name: String, storeType: CoreDataStorageType) {
        self.container = NSPersistentContainer(name: name)
        self.setupPersistentContainer(storeType)
        self.container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fail to load persistent store - \(error)")
            }
        }
    }
    
    
    // MARK: - Properties
    
    private var container: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    
    // MARK: - Public Methods
    
    /// Save the managed object to the persistent store.
    /// - Parameter block: A block object that takes a managed object context.
    ///                    You should initialize a managed object using this context.
    func save(_ block: @escaping (NSManagedObjectContext) -> Void) async throws {
        try await context.perform { [weak self] in
            guard let self = self else {
                throw CoreDataStorageError.deallocated
            }
                        
            do {
                block(context)
                try context.save()
            } catch {
                throw CoreDataStorageError.saveError(error)
            }
        }
    }
    
    
    /// Fetch the managed objects that meet the fetch request’s criteria.
    /// - Parameter request: The fetch request that specifies the search criteria.
    /// - Returns: Returns an array of the subclass of managed object.
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async throws -> [T] {
        try await context.perform { [weak self] in
            guard let self = self else {
                throw CoreDataStorageError.deallocated
            }
            
            do {
                return try context.fetch(request)
            } catch {
                throw CoreDataStorageError.fetchError(error)
            }
        }
    }
    
    
    /// Update the managed objects that meet the fetch request’s criteria.
    /// - Parameters:
    ///   - request: The fetch request that specifies the search criteria.
    ///   - block: A block object containg code that updates the managed object.
    func update<T: NSManagedObject>(_ request: NSFetchRequest<T>, _ block: @escaping (T) -> Void) async throws {
        try await context.perform { [weak self] in
            guard let self = self else {
                throw CoreDataStorageError.deallocated
            }
            
            do {
                let entities = try context.fetch(request)
                entities.forEach { block($0) }
                try context.save()
            } catch {
                throw CoreDataStorageError.updateError(error)
            }
        }
    }
    

    /// Delete the managed objects that meet the fetch request’s criteria.
    /// - Parameter request: The fetch request that specifies the search criteria.
    func delete<T: NSManagedObject>(_ request: NSFetchRequest<T>) async throws {
        try await context.perform { [weak self] in
            guard let self = self else {
                throw CoreDataStorageError.deallocated
            }
            
            do {
                let entities = try context.fetch(request)
                entities.forEach { self.context.delete($0) }
                try context.save()
            } catch {
                throw CoreDataStorageError.deleteError(error)
            }
        }
    }
    
    // MARK: - Private Methods
    
    func setupPersistentContainer(_ storageType: CoreDataStorageType) {
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.container.persistentStoreDescriptions = [description]
        }
    }
    
}

