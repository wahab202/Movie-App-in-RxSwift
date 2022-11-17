//
//  MovieDetailRepository.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import Foundation
import RxSwift

class MovieDetailRepository {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchMovieDetail(id: Int) -> Observable<MovieDetailDto> {
        let url = "https://api.themoviedb.org/3/movie/\(id)"
        return networkManager.exec(url: url, dto: MovieDetailDto.self)
    }
}
