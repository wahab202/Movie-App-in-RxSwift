//
//  Scope.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import Foundation

public protocol Scope {}

public extension Scope {

    @discardableResult
    @inline(__always)
    func also(configure: (inout Self) -> Void) -> Self {
        var this = self
        configure(&this)
        return this
    }

    @inline(__always)
    func with<T>(configure: (Self) -> T) -> T {
        return configure(self)
    }
}

extension NSObject: Scope {}
