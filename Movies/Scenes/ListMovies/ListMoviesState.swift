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
        self.movies = movies.enumerated().map { index, movie in
            presenter.presentMovie(movie, tapHandler: { [weak self] in
                self?.toggleFavorite(movie: movie, index: index)
            })
        }
        delegate?.didUpdateMovies()

        if error != nil {
            delegate?.didFailToFetchMovies()
        }
    }

    private func toggleFavorite(movie: Movie, index: Int) {
        favoritesManager.toggleIsFavorite(movie: movie)
        movies[index] = presenter.presentMovie(movie, tapHandler: { [weak self] in
            self?.toggleFavorite(movie: movie, index: index)
        })
        delegate?.didUpdateMovie(at: index)
    }
}
