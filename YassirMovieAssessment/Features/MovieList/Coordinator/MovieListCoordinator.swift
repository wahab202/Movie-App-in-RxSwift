//
//  MovieListCoordinator.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import Foundation
import UIKit

protocol MovieListCoordinator {
    var root: UIViewController { get }
}

extension MovieListCoordinator {
    
    func navigate(to route: MovieListViewModel.Route) {
        switch route {
        case .movieDetail(let id):
            showMovieDetail(id: id)
        }
    }
    
    func showMovieDetail(id: Int) {
        guard let nav = root.navigationController else {
            return
        }
        
        let vc = MovieDetailController(vm: .init(movieId: id))
        nav.pushViewController(vc, animated: true)
    }
}
