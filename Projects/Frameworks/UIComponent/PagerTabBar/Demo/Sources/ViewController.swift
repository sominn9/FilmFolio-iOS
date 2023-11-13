//
//  ViewController.swift
//  PagerTabBarDemo
//
//  Created by 신소민 on 11/13/23.
//

import PagerTabBar
import UIKit

class ViewController: UIViewController {
    
    private let pagerTabBarController = PagerTabBarController()
    
    var backgroundColors: [UIColor] {
        [.systemGreen, .systemOrange, .systemPurple, .systemGreen, .systemOrange, .systemPurple]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pagerTabBarController.dataSource = self
        addPagerTabBarController()
        configurePagerTabBarController()
    }
    
    private func addPagerTabBarController() {
        addChild(pagerTabBarController)
        view.addSubview(pagerTabBarController.view)
       
        pagerTabBarController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        pagerTabBarController.didMove(toParent: self)
    }
    
    private func configurePagerTabBarController() {
        var configuration = pagerTabBarController.configuration
        configuration.indicatorColor = .black
        configuration.indicatorHeight = 3
        configuration.tabBarItemWidth = 85
        configuration.tabBarHeight = 40
        configuration.tabBarItemConfiguration.selectedTextColor = .systemCyan
        pagerTabBarController.configuration = configuration
    }
    
}

extension ViewController: PagerTabBarControllerDataSource {
    
    func tabBarTitles(_ pagerTabBarController: PagerTabBar.PagerTabBarController) -> [String] {
        ["치킨", "피자", "야식", "고구마", "감자", "돈까스"]
    }
    
    func viewControllers(_ pagerTabBarController: PagerTabBar.PagerTabBarController) -> [UIViewController] {
        Array(0..<6).map { i in
            let vc = UIViewController()
            vc.view.backgroundColor = backgroundColors[i]
            return vc
        }
    }
    
}
