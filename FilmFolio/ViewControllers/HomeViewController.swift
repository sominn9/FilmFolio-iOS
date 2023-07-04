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

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = .systemBackground
        configureNavigationBar("영화")
    }
    
    private func configureNavigationBar(_ title: String) {
        
        // Create action.
        let actionTitle = title == "영화" ? "시리즈" : "영화"
        let action = UIAction(title: actionTitle) { [weak self] action in
            guard let self = self else { return }
            configureNavigationBar(actionTitle)
        }
        
        // Create button.
        let titleMenuButton = UIButton(configuration: .titleMenu(title, fontSize: 19))
        titleMenuButton.showsMenuAsPrimaryAction = true
        titleMenuButton.menu = UIMenu(children: [action])
        titleMenuButton.configurationUpdateHandler = { button in
            button.configuration = .titleMenu(title, fontSize: 19, state: button.state)
        }
        
        // Create bar button item.
        let barButtonItem = UIBarButtonItem(customView: titleMenuButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    // MARK: Binding
    
    private func bind() {
        
    }

}
