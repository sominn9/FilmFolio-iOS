//
//  SearchHomeViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

import SnapKit
import UIKit

final class SearchHomeViewController: UIViewController {
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        changeChildView(.movie)
    }
    
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationItem.title = String(localized: "Search")
    }
    
    private func changeChildView(_ menu: Menus) {
        switch menu {
        case .movie:
            let view = SearchView(placeholder: .init(localized: "Search Movie"))
            let viewModel = SearchViewModel<Movie>(networkManager: DefaultNetworkManager.shared)
            let viewController = SearchViewController(view: view, viewModel: viewModel)
            addChildView(viewController)
        case .series:
            let view = SearchView(placeholder: .init(localized: "Search TV Series"))
            let viewModel = SearchViewModel<Series>(networkManager: DefaultNetworkManager.shared)
            let viewController = SearchViewController(view: view, viewModel: viewModel)
            addChildView(viewController)
        }
    }
    
}
