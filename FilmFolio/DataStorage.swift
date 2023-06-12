//
//  DataStorage.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/12.
//

import Foundation

struct DataStorage<T> {
    
    private var array: [T]
    
    init(_ array: [T] = []) {
        self.array = array
    }
    
    subscript(index: Int) -> T? {
        if index >= array.count { return nil }
        return array[index]
    }
    
    // MARK: Append
    
    mutating func append(_ data: T) {
        array.append(data)
    }
    
    mutating func append(contentOf data: [T]) {
        array.append(contentsOf: data)
    }
    
    // MARK: Delete
    
    mutating func delete(at index: Int) -> T? {
        let deletedData = array.remove(at: index)
        return deletedData
    }
    
    mutating func delete(_ data: T) -> T? where T: Equatable {
        let index = array.firstIndex(where: { $0 == data })
        guard let index else { return nil }
        let deletedData = array.remove(at: index)
        return deletedData
    }
}
