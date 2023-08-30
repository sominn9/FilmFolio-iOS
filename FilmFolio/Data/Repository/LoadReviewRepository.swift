//
//  LoadReviewRepository.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/30.
//

import Foundation

protocol LoadReviewRepository {
    func load(id: Int, media: Media) async throws -> Review
}

struct DefaultLoadReviewRepository: LoadReviewRepository {
    
    // MARK: Properties
    
    private let reviewRepository: ReviewRepository
    
    
    // MARK: Initializing
    
    init(reviewRepository: ReviewRepository = DefaultReviewRepository()) {
        self.reviewRepository = reviewRepository
    }
    
    
    // MARK: Methods
    
    func load(id: Int, media: Media) async throws -> Review {
        
        // 작성된 리뷰가 있으면 저장소에서 가져와서 리턴
        if let review = try await reviewRepository.fetch(id, media) {
            return review
        }
        
        // 작성된 리뷰가 없으면 새로운 Review 객체 생성해서 리턴
        let new = Review(id: id, media: media, title: "", content: "", posterPath: nil, publishDate: "")
        return new
    }
    
}
