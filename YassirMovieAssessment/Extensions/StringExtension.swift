//
//  DateExtension.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import Foundation

extension String {
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
}
