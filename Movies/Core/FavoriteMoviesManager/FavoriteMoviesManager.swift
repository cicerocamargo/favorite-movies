import Foundation

protocol FavoriteMoviesManager {
    func isFavorite(movie: Movie) -> Bool
    func toggleIsFavorite(movie: Movie)
}

class DefaultFavoriteMoviesManager: FavoriteMoviesManager {

    static let standard = DefaultFavoriteMoviesManager()

    private let userDefaults: UserDefaults
    private var favoriteMoviesKey: String { return "favoriteMovies" }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func isFavorite(movie: Movie) -> Bool {
        let favoriteMovieIds = userDefaults.object(forKey: favoriteMoviesKey) as? [String] ?? []
        return favoriteMovieIds.contains(movie.uid)
    }

    func toggleIsFavorite(movie: Movie) {
        var favoriteMovieIds = userDefaults.value(forKey: favoriteMoviesKey) as? [String] ?? []
        if favoriteMovieIds.index(of: movie.uid) != nil {
            favoriteMovieIds = favoriteMovieIds.filter { $0 != movie.uid }
        } else {
            favoriteMovieIds.append(movie.uid)
        }
        userDefaults.set(favoriteMovieIds, forKey: favoriteMoviesKey)
    }
}
