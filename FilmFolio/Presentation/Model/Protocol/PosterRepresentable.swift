//
//  PosterRepresentable.swift
//  FilmFolio
//
//  Created by 신소민 on 10/28/23.
//

import Foundation

protocol PosterRepresentable: Hashable {
    var id: Int { get }
    func posterURL(size: Size) -> URL?
}
