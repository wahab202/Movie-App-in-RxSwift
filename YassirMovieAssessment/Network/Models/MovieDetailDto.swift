//
//  MovieDetailDto.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import Foundation

struct MovieDetailDto: Decodable {
    let backdropPath: String?
    let originalTitle: String?
    let overview: String?
    
    private enum CodingKeys : String, CodingKey {
            case overview,
                 backdropPath = "backdrop_path",
                 originalTitle = "original_title"
        }
}
