//
//  ReviewListAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 11/2/23.
//

import Swinject

final class ReviewListAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ReviewListViewModel.self) { _ in
            return ReviewListViewModel()
        }
        
        container.register(ReviewListViewController.self) { _ in
            return ReviewListViewController()
        }
    }
    
}
