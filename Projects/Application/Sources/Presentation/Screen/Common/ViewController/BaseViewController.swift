//
//  BaseViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/14.
//

import Resource
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTabBar()
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = FFColor.accentColor
    }
    
    func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBarController?.tabBar.standardAppearance = appearance
        tabBarController?.tabBar.scrollEdgeAppearance = appearance
        tabBarController?.tabBar.tintColor = FFColor.accentColor
    }
    
}
