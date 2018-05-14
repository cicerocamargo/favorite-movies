import Foundation

protocol ListMoviesStateDelegate: class {
    func didFailToFetchMovies()
    func didUpdateMovies()
    func didUpdateMovie(at index: Int)
}

class ListMoviesState {

    weak var delegate: ListMoviesStateDelegate?
    private(set) var movies: [MovieViewModel] = []
    private let favoritesManager: FavoriteMoviesManager
    private let movieProvider: MovieProvider
    private let presenter: ListMoviesPresenter

    init(favoritesManager: FavoriteMoviesManager, movieProvider: MovieProvider) {
        self.favoritesManager = favoritesManager
        self.movieProvider = movieProvider
        presenter = ListMoviesPresenter(favoritesManager: favoritesManager)
    }

    func fetchInitialData() {
        movieProvider.fetchMovies { [weak self] error, movies in
            self?.handleMoviesResult(error: error, movies: movies)
        }
    }

    private func handleMoviesResult(error: Error?, movies: [Movie]) {
        self.movies = presenter.presentMovies(movies)
        delegate?.didUpdateMovies()

        if error != nil {
            delegate?.didFailToFetchMovies()
        }
    }

    func handleTap(at index: Int) {
        guard index < movies.count else { return }
        let movie = movies[index].movie
        favoritesManager.toggleIsFavorite(movie: movie)
        movies[index] = presenter.presentMovie(movie)
        delegate?.didUpdateMovie(at: index)
    }
}
