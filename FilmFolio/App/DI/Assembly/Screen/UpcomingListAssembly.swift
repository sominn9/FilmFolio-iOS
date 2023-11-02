//
//  UpcomingListAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 11/2/23.
//

import Swinject

final class UpcomingListAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(UpcomingListViewModel.self) { _ in
            return UpcomingListViewModel()
        }
        
        container.register(UpcomingListView.self) { _ in
            return UpcomingListView()
        }
        
        container.register(UpcomingListViewController.self) { _ in
            return UpcomingListViewController()
        }
    }
    
}
