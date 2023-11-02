//
//  SeriesHomeAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 11/2/23.
//

import Swinject

final class SeriesHomeAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(SeriesHomeViewModel.self) { _ in
            return SeriesHomeViewModel()
        }
        
        container.register(SeriesHomeView.self) { _ in
            return SeriesHomeView()
        }
        
        container.register(SeriesHomeViewController.self) { _ in
            return SeriesHomeViewController()
        }
    }
    
}
