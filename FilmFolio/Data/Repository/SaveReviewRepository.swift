//
//  SaveReviewRepository.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/30.
//

import Foundation

protocol SaveReviewRepository {
    func save(_ review: Review) async throws
}

struct DefaultSaveReviewRepository: SaveReviewRepository {
    
    // MARK: Properties
    
    private let reviewRepository: ReviewRepository
    
    
    // MARK: Initializing
    
    init(reviewRepository: ReviewRepository = DefaultReviewRepository()) {
        self.reviewRepository = reviewRepository
    }
    
    
    // MARK: Methods
    
    func save(_ review: Review) async throws {
        if try await reviewRepository.fetch(review.id, review.media) == nil {
            var review = review
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormat.reviewFormat
            review.publishDate = formatter.string(from: Date())
            try await reviewRepository.save(review)
        } else {
            try await reviewRepository.update(review)
        }
    }
    
}
