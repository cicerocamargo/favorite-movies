import UIKit

private let favoriteMoviesKey = "favoriteMovies"

class MoviesViewController: UITableViewController {

    private var movies: [Movie] = []

    let favoriteMoviesManager = DefaultFavoriteMoviesManager.standard
    let movieProvider = OMDBMovieProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        // request movies data
        movieProvider.fetchMovies { error, movies in
            self.movies = movies
            self.tableView.reloadData()
            if error != nil {
                self.showErrorAlert()
            }
        }
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to load Batman Movies", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let movie = movies[indexPath.row]

        // set basic info
        cell.textLabel?.text = "\(movie.title) (\(movie.year))"

        // check if movie is favorite in the local database and set star icon accordingly
        cell.accessoryView = UIImageView(image: favoriteMoviesManager.isFavorite(movie: movie) ? #imageLiteral(resourceName: "star-full") : #imageLiteral(resourceName: "star-empty"))

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // toogle movie in favorites database
        let movie = movies[indexPath.row]
        favoriteMoviesManager.toggleIsFavorite(movie: movie)

        // tell table view to reload row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

