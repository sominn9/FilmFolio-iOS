//
//  SearchTabViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

import SnapKit
import UIKit

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
        pagerTabBarController.dataSource = self
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
        let viewControllers = [
            SearchViewController<Movie>(
                view: SearchView(placeholder: .init(localized: "Search Movie")),
                viewModel: SearchViewModel<Movie>(networkManager: DefaultNetworkManager.shared)
            ),
            SearchViewController<Series>(
                view: SearchView(placeholder: .init(localized: "Search TV Series")),
                viewModel: SearchViewModel<Series>(networkManager: DefaultNetworkManager.shared)
            )
        ]
        return viewControllers
    }
}
