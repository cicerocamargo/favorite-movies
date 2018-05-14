import UIKit

private let favoriteMoviesKey = "favoriteMovies"

class ListMoviesViewController: UITableViewController {

    private let state: ListMoviesState

    init(state: ListMoviesState) {
        self.state = state
        super.init(style: .plain)
        state.delegate = self
        title = "Batman Movies"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        state.fetchInitialData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let movie = state.movies[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = movie.fullTitle
        cell.accessoryView = UIImageView(image: movie.isFavorite ? #imageLiteral(resourceName: "star-full") : #imageLiteral(resourceName: "star-empty"))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        state.handleTap(at: indexPath.row)
    }
}

extension ListMoviesViewController: ListMoviesStateDelegate {
    func didFailToFetchMovies() {
        let alert = UIAlertController(title: "Error", message: "Failed to load Batman Movies", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func didUpdateMovies() {
        tableView.reloadData()
    }

    func didUpdateMovie(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }


}

