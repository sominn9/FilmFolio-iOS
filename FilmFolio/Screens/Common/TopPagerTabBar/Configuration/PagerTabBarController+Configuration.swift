//
//  PagerTabBarController+Configuration.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/28.
//

import UIKit

extension PagerTabBarController {
    
    struct Configuration {
        var tabBarHeight: CGFloat
        var tabBarItemWidth: CGFloat
        var tabBarItemConfiguration: TabBarItem.Configuration
        var indicatorHeight: CGFloat
        var indicatorColor: UIColor
        
        static func `default`() -> PagerTabBarController.Configuration {
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
