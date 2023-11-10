//
//  SearchTabViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

import SnapKit
import UIKit
import Utils

final class SearchTabViewController: BaseViewController {
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = .systemBackground
        configureNavigationTitle()
        configurePagerTabBarController()
    }
    
    private func configureNavigationTitle() {
        let button = UIButton(configuration: .titleMenu(
            String(localized: "Search"),
            fontSize: 19,
            showChevron: false
        ))
        button.isUserInteractionEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func configurePagerTabBarController() {
        let pagerTabBarController = PagerTabBarController()
        
        var configuration = pagerTabBarController.configuration
        configuration.indicatorColor = UIColor.accentColor
        configuration.tabBarItemConfiguration.selectedTextColor = UIColor.accentColor
        
        pagerTabBarController.dataSource = self
        pagerTabBarController.configuration = configuration
        addChildView(pagerTabBarController)
    }
    
}

// MARK: - PagerTabBarControllerDataSource

extension SearchTabViewController: PagerTabBarControllerDataSource {
    
    func tabBarTitles(_ pagerTabBarController: PagerTabBarController) -> [String] {
        let titles = [String(localized: "Movie"), String(localized: "Series")]
        return titles
    }
    
    func viewControllers(_ pagerTabBarController: PagerTabBarController) -> [UIViewController] {
        let vc1: SearchViewController<Movie> = DIContainer.shared.resolve(
            argument: String(localized: "Search Movie")
        )
        let vc2: SearchViewController<Series> = DIContainer.shared.resolve(
            argument: String(localized: "Search TV Series")
        )
        return [vc1, vc2]
    }
}
