//
//  TabBarItem+Configuration.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/28.
//

import UIKit

extension TabBarItem {
    
    public struct Configuration {
        public var title: String?
        public var font: UIFont
        public var textColor: UIColor
        public var selectedFont: UIFont
        public var selectedTextColor: UIColor
        
        public static func `default`() -> TabBarItem.Configuration {
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
