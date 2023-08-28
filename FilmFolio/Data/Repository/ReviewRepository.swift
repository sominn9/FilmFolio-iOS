//
//  ReviewRepository.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/28.
//

import CoreData
import Foundation

protocol ReviewRepository {
    func save()
    func fetch()
    func update()
    func delete()
}

struct DefaultReviewRepository {
    
    private let dataSource: CoreDataStorage
    
    init(dataSource: CoreDataStorage = .shared) {
        self.dataSource = dataSource
    }
    
    func save(_ data: Review) {
        
    }
    
}
