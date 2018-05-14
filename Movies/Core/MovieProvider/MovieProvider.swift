import Foundation

protocol MovieProvider {
    func fetchMovies(completionHandler: @escaping (Error?, [Movie]) -> Void)
}

class OMDBMovieProvider: MovieProvider {

    private let moviesURL = URL(string: "https://www.omdbapi.com/?s=Batman&apikey=d0e82791")!

    func fetchMovies(completionHandler: @escaping (Error?, [Movie]) -> Void) {
        URLSession.shared.dataTask(with: moviesURL) { data, _, error in
            guard error == nil, let data = data else {
                debugPrint(error)
                completionHandler(error, [])
                return
            }

            do {
                let response = try JSONDecoder().decode(OMDBSearchResponse<Movie>.self, from: data)
                completionHandler(nil, response.search)
            } catch {
                debugPrint(error)
                completionHandler(error, [])
            }
        }.resume()
    }
}
