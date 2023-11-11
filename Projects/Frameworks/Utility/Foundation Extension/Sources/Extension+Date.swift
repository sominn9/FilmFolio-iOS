//
//  Extension+Date.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import Foundation

public extension Date {
    
    static func tomorrow() -> String {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: tomorrow ?? Date())
    }
    
}
