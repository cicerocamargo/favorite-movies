//
//  MovieExtensions.swift
//  MoviesTests
//
//  Created by Cícero Camargo on 13/05/18.
//  Copyright © 2018 Camargo. All rights reserved.
//

import Foundation
@testable import Movies

extension Movie {

    static func buildAny(imdbId: String? = nil) -> Movie {
        return Movie(title: "Some title",
                     year: "2018",
                     imdbId: imdbId,
                     type: "Movie",
                     poster: nil)
    }
}

