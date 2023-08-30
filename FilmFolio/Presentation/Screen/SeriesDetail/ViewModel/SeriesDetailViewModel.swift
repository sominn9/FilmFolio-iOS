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
        let reviewButtonPressed: Observable<Void>
    }
    
    struct Output {
        let seriesDetail: Observable<SeriesDetail>
        let loadedReview: Observable<Review>
    }
    
    
    // MARK: Properties
    
    private let id: Int
    private let networkManager: NetworkManager
    private let loadReviewRepository: LoadReviewRepository
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(
        id: Int,
        networkManager: NetworkManager = DefaultNetworkManager.shared,
        loadReviewRepository: LoadReviewRepository = DefaultLoadReviewRepository()
    ) {
        self.id = id
        self.networkManager = networkManager
        self.loadReviewRepository = loadReviewRepository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: Input) -> Output {
        let seriesDetail = BehaviorSubject<SeriesDetail>(value: .default())
        let loadedReview = PublishSubject<Review>()
        
        input.fetchSeriesDetail
            .map { EndpointCollection.seriesDetail(id: id) }
            .flatMap { networkManager.request($0) }
            .catchAndReturn(SeriesDetail.default())
            .bind(to: seriesDetail)
            .disposed(by: disposeBag)
        
        input.reviewButtonPressed
            .subscribe(onNext: {
                Task {
                    var review = try await loadReviewRepository.load(id: id, media: .series)
                    review.title = (try? seriesDetail.value().name) ?? ""
                    review.posterPath = try? seriesDetail.value().posterPath
                    loadedReview.onNext(review)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            seriesDetail: seriesDetail,
            loadedReview: loadedReview
        )
    }
    
}
