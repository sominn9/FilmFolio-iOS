//
//  ReuseIdentifier.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/10.
//

import UIKit

protocol ReuseIdentifier {
    static var identifier: String { get }
}

extension ReuseIdentifier {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: ReuseIdentifier { }
