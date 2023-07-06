//
//  HomeViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/03.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Constants
    
    enum Menus: CaseIterable {
        case movie
        case series
        
        var description: String {
            switch self {
            case .movie:
                return String(localized: "Movie")
            case .series:
                return String(localized: "Series")
            }
        }
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = .systemBackground
        change(.movie)
    }
    
    private func change(_ title: Menus) {
        changeTitleMenu(title)
        changeChildView(title)
    }
    
    private func changeTitleMenu(_ title: Menus) {
        
        // Create action.
        let actions = Menus.allCases.filter({ $0 != title }).map { menu in
            return UIAction(title: menu.description) { [weak self] _ in
                guard let self = self else { return }
                change(menu)
            }
        }
        
        // Create button.
        let titleMenuButton = UIButton(configuration: .titleMenu(title.description, fontSize: 19))
        titleMenuButton.showsMenuAsPrimaryAction = true
        titleMenuButton.menu = UIMenu(children: actions)
        titleMenuButton.configurationUpdateHandler = { button in
            let text = button.titleLabel?.text ?? ""
            button.configuration = .titleMenu(text, fontSize: 19, state: button.state)
        }
        
        // Create bar button item.
        let barButtonItem = UIBarButtonItem(customView: titleMenuButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func changeChildView(_ title: Menus) {
        switch title {
        case .movie:
            let view = MovieHomeView()
            let viewModel = MovieHomeViewModel(networkManager: DefaultNetworkManager.shared)
            let viewController = MovieHomeViewController(view: view, viewModel: viewModel)
            addChildView(viewController)
        case .series:
            let view = SeriesHomeView()
            let viewModel = SeriesHomeViewModel(networkManager: DefaultNetworkManager.shared)
            let viewController = SeriesHomeViewController(view: view, viewModel: viewModel)
            addChildView(viewController)
        }
    }
    
    private func addChildView(_ viewController: UIViewController) {
        
        // Add the view controller to the container.
        addChild(viewController)
        view.addSubview(viewController.view)

        // Create and activate the constraints for the child’s view.
        viewController.view.snp.makeConstraints {
            $0.edges.equalTo(view.snp.edges)
        }

        // Notify the child view controller that the move is complete.
        viewController.didMove(toParent: self)
    }

}
