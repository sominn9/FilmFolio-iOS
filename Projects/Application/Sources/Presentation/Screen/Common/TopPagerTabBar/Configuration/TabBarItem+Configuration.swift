//
//  TabBarItem+Configuration.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/28.
//

import UIKit

extension TabBarItem {
    
    struct Configuration {
        var title: String?
        var font: UIFont
        var textColor: UIColor
        var selectedFont: UIFont
        var selectedTextColor: UIColor
        
        static func `default`() -> TabBarItem.Configuration {
            Configuration (
                title: nil,
                font: .systemFont(ofSize: 17),
                textColor: .darkGray,
                selectedFont: .systemFont(ofSize: 17, weight: .bold),
                selectedTextColor: .tintColor
            )
        }
    }
    
}
