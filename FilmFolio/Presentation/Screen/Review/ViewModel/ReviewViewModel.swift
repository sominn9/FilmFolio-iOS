//
//  ReviewViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/22.
//

import Foundation
import RxSwift

struct ReviewViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        var saveButtonPressed: Observable<Void>
        var text: Observable<String>
    }
    
    struct Output {
        var title: Observable<String>
        var posterPath: Observable<String?>
    }
    
    // MARK: Initializing
    
    init() {
        
    }
    
    
    // MARK: Methods
    
    func transform(_ input: ReviewViewModel.Input) -> ReviewViewModel.Output {
        
        return Output(
            title: Observable.just(""),
            posterPath: Observable.just("")
        )
    }
    
}
