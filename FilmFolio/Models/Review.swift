//
//  Review.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/20.
//

import Foundation

struct Review: Hashable {
    private let id = UUID()
    let title: String
    let content: String
    let posterPath: String
    let publishDate: Date
    
    init(title: String, content: String, posterPath: String, publishDate: Date) {
        self.title = title
        self.content = content
        self.posterPath = posterPath
        self.publishDate = publishDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (_ lhs: Review, _ rhs: Review) -> Bool {
        lhs.id == rhs.id
    }
}
