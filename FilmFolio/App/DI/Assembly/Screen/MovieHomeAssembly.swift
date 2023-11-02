//
//  MovieHomeAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 11/2/23.
//

import Swinject

final class MovieHomeAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MovieHomeViewModel.self) { _ in
            return MovieHomeViewModel()
        }
        
        container.register(MovieHomeView.self) { _ in
            return MovieHomeView()
        }
        
        container.register(MovieHomeViewController.self) { _ in
            return MovieHomeViewController()
        }
    }
    
}
