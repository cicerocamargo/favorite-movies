import Foundation

class ListMoviesPresenter {

    private let favoritesManager: FavoriteMoviesManager

    init(favoritesManager: FavoriteMoviesManager) {
        self.favoritesManager = favoritesManager
    }

    func presentMovie(_ movie: Movie, tapHandler: @escaping () -> Void) -> MovieViewModel {
        return MovieViewModel(
            fullTitle: "\(movie.title) (\(movie.year))",
            isFavorite: favoritesManager.isFavorite(movie: movie),
            tapHandler: tapHandler
        )
    }
}
