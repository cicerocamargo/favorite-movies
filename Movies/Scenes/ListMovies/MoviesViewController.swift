import UIKit

private let favoriteMoviesKey = "favoriteMovies"

class MoviesViewController: UITableViewController {

    private var movies: [Movie] = []

    let favoriteMoviesManager = DefaultFavoriteMoviesManager.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // request movies data
        let url = URL(string: "https://www.omdbapi.com/?s=Batman&apikey=d0e82791")!
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.handleResponse(data: data, error: error)
            }
        }.resume()
    }

    // process movie data or error
    func handleResponse(data: Data?, error: Error?) {
        guard error == nil, let data = data else {
            self.showErrorAlert()
            return
        }

        do {
            let response = try JSONDecoder().decode(OMDBSearchResponse<Movie>.self, from: data)
            self.movies = response.search
            self.tableView.reloadData()
        } catch {
            debugPrint(error)
            self.showErrorAlert()
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

