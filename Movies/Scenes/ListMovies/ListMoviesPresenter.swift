import Foundation

class ListMoviesPresenter {

    private let favoritesManager: FavoriteMoviesManager

    init(favoritesManager: FavoriteMoviesManager) {
        self.favoritesManager = favoritesManager
    }

    func presentMovie(_ movie: Movie) -> MovieViewModel {
        return MovieViewModel(movie: movie,
                              fullTitle: "\(movie.title) (\(movie.year))",
                              isFavorite: favoritesManager.isFavorite(movie: movie))
    }

    func presentMovies(_ movies: [Movie]) -> [MovieViewModel] {
        return movies.map { presentMovie($0) }
    }
}
