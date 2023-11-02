//
//  SearchAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 11/2/23.
//

import Swinject

final class SearchAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(SearchViewModel<Movie>.self) { _ in
            return SearchViewModel(media: .movie)
        }
        
        container.register(SearchViewModel<Series>.self) { _ in
            return SearchViewModel(media: .series)
        }
        
        container.register(SearchView.self) { (_, placeholder: String) in
            return SearchView(placeholder: placeholder)
        }
        
        container.register(SearchViewController<Movie>.self) { (_, placeholder: String) in
            return SearchViewController(placeholder: placeholder)
        }
        
        container.register(SearchViewController<Series>.self) { (_, placeholder: String) in
            return SearchViewController(placeholder: placeholder)
        }
    }
    
}
