//
//  MovieListRepository.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 15/11/2022.
//

import Foundation
import RxSwift

class MovieListRepository {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchMovieList() -> Observable<MovieListDto> {
        let url = "https://api.themoviedb.org/3/discover/movie"
        return networkManager.exec(url: url, dto: MovieListDto.self)
    }
}
