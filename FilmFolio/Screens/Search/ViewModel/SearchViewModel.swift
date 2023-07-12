//
//  SearchViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/10.
//

import Foundation
import RxSwift

struct SearchViewModel<Item> {
    
    // MARK: Input & Output
    
    struct Input {
        let searchText: Observable<String>
    }
    
    struct Output {
        
    }
    
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    private let items = PublishSubject<[Item]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    // MARK: Methods
    
    func transform(_ input: SearchViewModel.Input) -> SearchViewModel.Output {
        
        input.searchText
            .subscribe(onNext: { text in
                print(text)
            })
            .disposed(by: disposeBag)
        
        return SearchViewModel.Output()
    }
    
}
