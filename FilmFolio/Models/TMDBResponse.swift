//
//  TMDBResponse.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/13.
//

import Foundation

struct TMDBResponse<Item: Decodable>: Decodable {
    let page: Int
    let results: [Item]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
