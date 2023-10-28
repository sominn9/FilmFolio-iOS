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
        let view1 = SearchView(placeholder: .init(localized: "Search Movie"))
        let vm1 = SearchViewModel<Movie>(media: .movie)
        let vc1 = SearchViewController(view: view1, viewModel: vm1)
        
        let view2 = SearchView(placeholder: .init(localized: "Search TV Series"))
        let vm2 = SearchViewModel<Series>(media: .series)
        let vc2 = SearchViewController(view: view2, viewModel: vm2)
        
        return [vc1, vc2]
    }
}
