//
//  Bookmark.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/20.
//

import Foundation

struct Bookmark: Hashable {
    private let id = UUID()
    let type: Menus
    let tmdbID: Int
    let title: String
    let overview: String
    let posterPath: String
    let bookmarkDate: Date
    
    init(type: Menus, tmdbID: Int, title: String, overview: String, posterPath: String, bookmarkDate: Date) {
        self.type = type
        self.tmdbID = tmdbID
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.bookmarkDate = bookmarkDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (_ lhs: Bookmark, _ rhs: Bookmark) -> Bool {
        lhs.id == rhs.id
    }
}
