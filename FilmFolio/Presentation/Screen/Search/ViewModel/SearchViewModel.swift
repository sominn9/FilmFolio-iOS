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
    
    private let movieRepository: MovieRepository
    private let seriesRepository: SeriesRepository
    private let items = PublishSubject<[Item]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(
        movieRepository: MovieRepository = DefaultMovieRepository(),
        seriesRepository: SeriesRepository = DefaultSeriesRepository()
    ) {
        self.movieRepository = movieRepository
        self.seriesRepository = seriesRepository
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
            .flatMap { movieRepository.search(query: $0, page: 1) }
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
            .flatMap { seriesRepository.search(query: $0, page: 1) }
            .catchAndReturn([])
            .subscribe(onNext: { result in
                if let result = result as? [Item] {
                    items.onNext(result)
                }
            })
            .disposed(by: disposeBag)
        
        return SearchViewModel.Output(items: items)
    }
    
}
