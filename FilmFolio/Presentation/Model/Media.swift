//
//  Menus.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

import Foundation

enum Media: String, CaseIterable {
    case movie
    case series
    
    var description: String {
        switch self {
        case .movie: return String(localized: "Movie")
        case .series: return String(localized: "Series")
        }
    }
}
