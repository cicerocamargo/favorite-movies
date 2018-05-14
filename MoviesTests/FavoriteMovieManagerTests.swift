import XCTest
@testable import Movies

class FavoriteMovieManagerTests: XCTestCase {

    var manager: DefaultFavoriteMoviesManager!

    override func setUp() {
        super.setUp()
        manager = DefaultFavoriteMoviesManager(userDefaults: UserDefaults(suiteName: UUID().uuidString)!)
    }
    
    func testCanAddAndRemoveFavoriteMovie() {
        let movie = Movie.buildAny()
        XCTAssertFalse(manager.isFavorite(movie: movie))
        manager.toggleIsFavorite(movie: movie)
        XCTAssertTrue(manager.isFavorite(movie: movie))
        manager.toggleIsFavorite(movie: movie)
        XCTAssertFalse(manager.isFavorite(movie: movie))
    }

    func testCanManageMultipleFavoriteMovies() {
        let movie1 = Movie.buildAny(imdbId: UUID().uuidString)
        let movie2 = Movie.buildAny(imdbId: UUID().uuidString)
        XCTAssertFalse(manager.isFavorite(movie: movie1))
        XCTAssertFalse(manager.isFavorite(movie: movie2))

        manager.toggleIsFavorite(movie: movie1)
        XCTAssertTrue(manager.isFavorite(movie: movie1))
        XCTAssertFalse(manager.isFavorite(movie: movie2))

        manager.toggleIsFavorite(movie: movie2)
        XCTAssertTrue(manager.isFavorite(movie: movie1))
        XCTAssertTrue(manager.isFavorite(movie: movie2))

        manager.toggleIsFavorite(movie: movie1)
        XCTAssertFalse(manager.isFavorite(movie: movie1))
        XCTAssertTrue(manager.isFavorite(movie: movie2))

        manager.toggleIsFavorite(movie: movie2)
        XCTAssertFalse(manager.isFavorite(movie: movie1))
        XCTAssertFalse(manager.isFavorite(movie: movie2))
    }
}
