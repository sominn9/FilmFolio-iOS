//
//  Extension+Collection.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/07.
//

import Foundation

extension Collection where Element: Hashable {
    
    func isIntersect<C: Collection>(with collection: C) -> Bool where Element == C.Element {
        return Set(self).intersection(Set(collection)).count > 0
    }
}
