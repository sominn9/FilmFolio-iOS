//
//  ReviewAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 11/2/23.
//

import Swinject

final class ReviewAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ReviewViewModel.self) { (_, review: Review) in
            return ReviewViewModel(review: review)
        }
        
        container.register(ReviewViewController.self) { (_, review: Review) in
            return ReviewViewController(review: review)
        }
    }
    
}
