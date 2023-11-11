//
//  PagerTabBarController+Configuration.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/28.
//

import UIKit

extension PagerTabBarController {
    
    public struct Configuration {
        public var tabBarHeight: CGFloat
        public var tabBarItemWidth: CGFloat
        public var tabBarItemConfiguration: TabBarItem.Configuration
        public var indicatorHeight: CGFloat
        public var indicatorColor: UIColor
        
        public static func `default`() -> PagerTabBarController.Configuration {
            Configuration(
                tabBarHeight: 40.0,
                tabBarItemWidth: 80.0,
                tabBarItemConfiguration: .default(),
                indicatorHeight: 3.0,
                indicatorColor: .tintColor
            )
        }
    }
    
}
