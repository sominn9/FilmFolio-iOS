//
//  RootTabBarController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

import Resource
import UIKit

final class RootTabBarController: UITabBarController {
    
    // MARK: Initializing
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    // MARK: Methods
    
    private func configure() {
        setViewControllers()
        setTabBarItems()
    }
    
    private func setViewControllers() {
        let rootViewControllers = [
            HomeTabViewController(),
            SearchTabViewController(),
            DIContainer.shared.resolve(UpcomingListViewController.self),
            DIContainer.shared.resolve(ReviewListViewController.self)
        ]
        
        self.setViewControllers(
            rootViewControllers.map {
                UINavigationController(rootViewController: $0)
            },
            animated: true
        )
    }
    
    private func setTabBarItems() {
        guard let viewControllers else { return }
        viewControllers[0].tabBarItem = UITabBarItem(
            title: TabBarItemsLocalization.home.text,
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        viewControllers[1].tabBarItem = UITabBarItem(
            title: TabBarItemsLocalization.search.text,
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        viewControllers[2].tabBarItem = UITabBarItem(
            title: TabBarItemsLocalization.upcoming.text,
            image: UIImage(systemName: "play.rectangle"),
            tag: 2
        )
        viewControllers[3].tabBarItem = UITabBarItem(
            title: TabBarItemsLocalization.review.text,
            image: UIImage(systemName: "text.book.closed"),
            tag: 3
        )
    }
    
}
