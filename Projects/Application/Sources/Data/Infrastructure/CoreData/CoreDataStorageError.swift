//
//  CoreDataStorageError.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/29.
//

import Foundation

enum CoreDataStorageError: Error {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
    case updateError(Error)
    case deallocated
}
