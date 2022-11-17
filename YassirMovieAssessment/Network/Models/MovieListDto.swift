//
//  MovieListDto.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 16/11/2022.
//

import Foundation

struct MovieListDto: Decodable {
    let results: [MovieDto]
}

struct MovieDto: Decodable {
    let title: String?
    let releaseDate: String?
    let posterPath: String?
    let id: Int
    
    private enum CodingKeys : String, CodingKey {
            case title,
                 id,
                 releaseDate = "release_date",
                 posterPath = "poster_path"
        }
}
