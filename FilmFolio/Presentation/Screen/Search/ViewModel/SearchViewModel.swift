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
    private let movieRepository: MovieRepository
    private let items = PublishSubject<[Item]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(
        networkManager: NetworkManager = DefaultNetworkManager.shared,
        movieRepository: MovieRepository = DefaultMovieRepository()
    ) {
        self.networkManager = networkManager
        self.movieRepository = movieRepository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: SearchViewModel.Input) -> SearchViewModel.Output {
        
        input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                if $0.isEmpty {
                    items.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { _ in Item.self == Movie.self }
            .filter { !$0.isEmpty }
            .flatMap { movieRepository.search(query: $0, page: 1)}
            .catchAndReturn([])
            .subscribe(onNext: { result in
                if let result = result as? [Item] {
                    items.onNext(result)
                }
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { _ in Item.self == Series.self }
            .filter { !$0.isEmpty }
            .map { EndpointCollection.searchSeries(query: $0) }
            .flatMap { networkManager.request($0) }
            .map { (r: TMDBResponse<Item>) in r.results }
            .catchAndReturn([])
            .bind(to: items)
            .disposed(by: disposeBag)
        
        return SearchViewModel.Output(items: items)
    }
    
}
