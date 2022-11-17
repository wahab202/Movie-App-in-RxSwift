//
//  MovieListCoordinator.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import Foundation

final class MovieListCoordinator {
    
    enum Route {
        case movieDetail(id: Int)
    }
    
    func navigate(to route: Route) {
        switch route {
        case .movieDetail(let id):
            showMovieDetail(id: id)
        }
    }
    
    func showMovieDetail(id: Int) {
        print(id)
    }
}
