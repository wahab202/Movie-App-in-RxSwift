//
//  MovieDetailViewModel.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieDetailViewModel {
    
    private let movieDetailRepository: MovieDetailRepository
    private let movieId: Int
        
    init(movieId: Int,
         movieDetailRepository: MovieDetailRepository = MovieDetailRepository()) {
        self.movieDetailRepository = movieDetailRepository
        self.movieId = movieId
    }
}

extension MovieDetailViewModel {
    struct Input {}
    
    struct Output {
        let posterURL: Driver<String>
        let title: Driver<String>
        let description: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let detail = movieDetailRepository
            .fetchMovieDetail(id: movieId)
        
        let description = detail.compactMap { $0.overview }
            .asDriver(onErrorDriveWith: .empty())
        
        let title = detail.compactMap { $0.originalTitle }
            .asDriver(onErrorDriveWith: .empty())
        
        let posterUrl = detail.compactMap { "https://image.tmdb.org/t/p/w500/\($0.backdropPath ?? "")" }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            posterURL: posterUrl,
            title: title,
            description: description
        )
    }
}

