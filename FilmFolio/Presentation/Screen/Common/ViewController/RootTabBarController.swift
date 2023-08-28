//
//  RootTabBarController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

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
        let viewControllers = [
            UINavigationController(rootViewController: HomeTabViewController()),
            UINavigationController(rootViewController: SearchTabViewController()),
            UINavigationController(rootViewController: UpcomingViewController(
                view: UpcomingView(),
                viewModel: UpcomingViewModel(networkManager: DefaultNetworkManager.shared)
            )),
            UINavigationController()
        ]
        self.setViewControllers(viewControllers, animated: true)
    }
    
    private func setTabBarItems() {
        guard let viewControllers else { return }
        viewControllers[0].tabBarItem = UITabBarItem(
            title: String(localized: "Home"),
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        viewControllers[1].tabBarItem = UITabBarItem(
            title: String(localized: "Search"),
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        viewControllers[2].tabBarItem = UITabBarItem(
            title: String(localized: "Upcoming"),
            image: UIImage(systemName: "play.rectangle"),
            tag: 2
        )
        viewControllers[3].tabBarItem = UITabBarItem(
            title: "My",
            image: UIImage(systemName: "suit.heart.fill"),
            tag: 3
        )
    }
    
}
