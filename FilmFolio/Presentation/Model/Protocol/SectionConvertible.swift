//
//  SectionConvertible.swift
//  FilmFolio
//
//  Created by 신소민 on 10/28/23.
//

import Foundation

protocol SectionConvertible {
    associatedtype EnumType
    var indexToSection: ((Int) -> EnumType?)? { get set }
}
