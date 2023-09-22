//
//  HomeTabViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/03.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeTabViewController: BaseViewController {
    
    // MARK: Properties
    
    private var childViewController: UIViewController?
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    // MARK: Methods
    
    private func configure() {
        change(.movie)
    }
    
    private func change(_ media: Media) {
        updateTitleMenu(media)
        changeChildView(media)
    }
    
    private func updateTitleMenu(_ media: Media) {
        
        // Create action.
        let actions = Media.allCases.filter({ $0 != media }).map { other in
            return UIAction(title: other.description) { [weak self] _ in
                guard let self = self else { return }
                change(other)
            }
        }
        
        // Create button.
        let titleMenuButton = UIButton(configuration: .titleMenu(media.description, fontSize: 19))
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
    
    private func changeChildView(_ media: Media) {
        var viewController: UIViewController
        
        switch media {
        case .movie:
            viewController = MovieHomeViewController(
                view: MovieHomeView(),
                viewModel: MovieHomeViewModel()
            )
        case .series:
            viewController = SeriesHomeViewController(
                view: SeriesHomeView(),
                viewModel: SeriesHomeViewModel()
            )
        }
        
        deleteChildView()
        addChildView(viewController)
        childViewController = viewController
    }
    
    private func deleteChildView() {
        childViewController?.willMove(toParent: nil)
        childViewController?.view.snp.removeConstraints()
        childViewController?.view.removeFromSuperview()
        childViewController?.removeFromParent()
    }

}
