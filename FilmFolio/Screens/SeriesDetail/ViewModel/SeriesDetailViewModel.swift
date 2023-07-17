//
//  SeriesDetailViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import Foundation
import RxSwift

struct SeriesDetailViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        let fetchSeriesDetail: Observable<Void>
    }
    
    struct Output {
        let seriesDetail: Observable<SeriesDetail>
    }
    
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    private let id: Int
    private let seriesDetail = PublishSubject<SeriesDetail>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(networkManager: NetworkManager, id: Int) {
        self.networkManager = networkManager
        self.id = id
    }
    
    
    // MARK: Methods
    
    func transform(_ input: SeriesDetailViewModel.Input) -> SeriesDetailViewModel.Output {
        
        input.fetchSeriesDetail
            .map { EndpointCollection.seriesDetail(id: id) }
            .flatMap { networkManager.request($0) }
            .catchAndReturn(SeriesDetail.default())
            .bind(to: seriesDetail)
            .disposed(by: disposeBag)
        
        return SeriesDetailViewModel.Output(seriesDetail: seriesDetail)
    }
    
}
