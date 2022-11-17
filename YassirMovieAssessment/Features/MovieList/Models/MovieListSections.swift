//
//  MovieListSections.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 16/11/2022.
//

import Foundation
import RxDataSources

struct MovieListSection {
  var items: [Item]
}

extension MovieListSection: SectionModelType {
  typealias Item = MovieListCellModel

   init(original: MovieListSection, items: [Item]) {
    self = original
    self.items = items
  }
}
