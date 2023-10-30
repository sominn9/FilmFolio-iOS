//
//  MovieDetailAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 10/30/23.
//

import Swinject

final class MovieDetailAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MovieDetailViewModel.self) { (_, id: Int) in
            return MovieDetailViewModel(id: id)
        }
        
        container.register(MovieDetailView.self) { _ in
            return MovieDetailView()
        }
        
        container.register(MovieDetailViewController.self) { (_, id: Int) in
            return MovieDetailViewController(id: id)
        }
    }
    
}
