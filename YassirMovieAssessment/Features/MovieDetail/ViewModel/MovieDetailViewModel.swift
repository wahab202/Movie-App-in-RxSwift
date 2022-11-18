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
    private let bag = DisposeBag()
        
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
        let error: Driver<String>
        let loading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let errorRelay = PublishRelay<String>()
        
        let detail = movieDetailRepository
            .fetchMovieDetail(id: movieId)
        
        let description = detail.compactMap { $0.overview }
            .asDriver(onErrorDriveWith: .empty())
        
        let title = detail.compactMap { $0.originalTitle }
            .asDriver(onErrorDriveWith: .empty())
        
        let posterUrl = detail.compactMap { "https://image.tmdb.org/t/p/w500/\($0.backdropPath ?? "")" }
            .asDriver(onErrorDriveWith: .empty())
        
        detail.subscribe(onError: { error in
            errorRelay.accept(error.localizedDescription)
        }).disposed(by: bag)
        
        let error = errorRelay
            .asDriver(onErrorDriveWith: .empty())
        
        let loading = detail.map { _ in return false }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            posterURL: posterUrl,
            title: title,
            description: description,
            error: error,
            loading: loading
        )
    }
}

