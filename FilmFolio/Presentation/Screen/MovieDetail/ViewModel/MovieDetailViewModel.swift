//
//  MovieDetailViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/16.
//

import Foundation
import RxSwift

struct MovieDetailViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        let fetchMovieDetail: Observable<Void>
    }
    
    struct Output {
        let movieDetail: Observable<MovieDetail>
    }
    
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    private let id: Int
    private let movieDetail = PublishSubject<MovieDetail>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(networkManager: NetworkManager, id: Int) {
        self.networkManager = networkManager
        self.id = id
    }
    
    
    // MARK: Methods
    
    func transform(_ input: MovieDetailViewModel.Input) -> MovieDetailViewModel.Output {
        
        input.fetchMovieDetail
            .map { EndpointCollection.movieDetail(id: id) }
            .flatMap { networkManager.request($0) }
            .catchAndReturn(MovieDetail.default())
            .bind(to: movieDetail)
            .disposed(by: disposeBag)
        
        return MovieDetailViewModel.Output(movieDetail: movieDetail)
    }
    
}
