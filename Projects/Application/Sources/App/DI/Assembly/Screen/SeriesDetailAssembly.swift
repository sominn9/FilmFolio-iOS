//
//  SeriesDetailAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 10/30/23.
//

import Swinject

final class SeriesDetailAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(SeriesDetailViewModel.self) { (_, id: Int) in
            return SeriesDetailViewModel(id: id)
        }
        
        container.register(SeriesDetailView.self) { _ in
            return SeriesDetailView()
        }
        
        container.register(SeriesDetailViewController.self) { (_, id: Int) in
            return SeriesDetailViewController(id: id)
        }
    }
    
}
