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
    
    enum Menus: String, CaseIterable {
        case movie = "영화"
        case series = "시리즈"
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchChildView(.movie)
    }
    
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = .systemBackground
        configureNavigationBar(.movie)
    }
    
    private func configureNavigationBar(_ title: Menus) {
        
        // Create action.
        let actions = Menus.allCases.filter({ $0 != title }).map { menu in
            return UIAction(title: menu.rawValue) { [weak self] _ in
                guard let self = self else { return }
                configureNavigationBar(menu)
                switchChildView(menu)
            }
        }
        
        // Create button.
        let titleMenuButton = UIButton(configuration: .titleMenu(title.rawValue, fontSize: 19))
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
    
    private func switchChildView(_ title: Menus) {
        guard let size = view.window?.windowScene?.screen.bounds.size else { return }
        switch title {
        case .movie:
            let view = MovieHomeView(screenSize: size)
            let viewModel = MovieHomeViewModel(networkManager: DefaultNetworkManager.shared)
            let viewController = MovieHomeViewController(view: view, viewModel: viewModel)
            addChildView(viewController)
        case .series:
            break
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
    
    
    // MARK: Binding
    
    private func bind() {
        
    }

}
