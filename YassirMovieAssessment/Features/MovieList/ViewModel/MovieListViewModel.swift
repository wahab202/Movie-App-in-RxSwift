//
//  MovieListViewModel.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 15/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieListViewModel {
    
    private let movieListRepository: MovieListRepository
        
    init(movieListRepository: MovieListRepository = MovieListRepository()) {
        self.movieListRepository = movieListRepository
    }
}

extension MovieListViewModel {
    struct Input {}
    
    struct Output {
        let sections: Driver<[MovieListSection]>
    }
    
    func transform(input: Input) -> Output {
        let movieList = movieListRepository
            .fetchMovieList()
        
        let items = movieList.map { movieList -> [MovieListCellModel] in
            return movieList.results.map {
                MovieListCellModel(title: $0.title,
                                   releaseDate: $0.releaseDate.toDate(),
                                   imageUrl: $0.posterPath)
            }
        }
        
        let sections = items.map { movieItems -> [MovieListSection] in
             return [ MovieListSection(items: movieItems)]
        }.asDriver(onErrorDriveWith: .empty())
        
        return Output(sections: sections)
    }
}
