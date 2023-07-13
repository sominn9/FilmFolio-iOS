//
//  SearchViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/10.
//

import Foundation
import RxSwift

struct SearchViewModel<Item: Decodable> {
    
    // MARK: Input & Output
    
    struct Input {
        let searchText: Observable<String>
    }
    
    struct Output {
        let items: PublishSubject<[Item]>
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
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter {
                if !$0.isEmpty { return true }
                items.onNext([])
                return false
            }
            .map {
                switch Item.self {
                case is Movie.Type:
                    return EndpointCollection.searchMovie(query: $0)
                case is Series.Type:
                    return EndpointCollection.searchSeries(query: $0)
                default:
                    fatalError("Unhandled Item type!")
                }
            }
            .flatMap { networkManager.request($0) }
            .map { (r: TMDBResponse<Item>) in r.results }
            .catchAndReturn([])
            .bind(to: items)
            .disposed(by: disposeBag)
        
        return SearchViewModel.Output(items: items)
    }
    
}
