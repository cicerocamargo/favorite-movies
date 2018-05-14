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

