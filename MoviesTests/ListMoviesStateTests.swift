//
//  ListMoviesStateTests.swift
//  MoviesTests
//
//  Created by Cícero Camargo on 14/05/18.
//  Copyright © 2018 Camargo. All rights reserved.
//

import XCTest
@testable import Movies

class ListMoviesStateTests: XCTestCase {

    var state: ListMoviesState! // SUT
    var favoritesManagerMock: FavoriteMoviesManagerMock!
    var movieProviderMock: MovieProviderMock!
    var delegateMock: ListMoviesStateDelegateMock!

    override func setUp() {
        super.setUp()
        favoritesManagerMock = FavoriteMoviesManagerMock()
        movieProviderMock = MovieProviderMock()
        delegateMock = ListMoviesStateDelegateMock()
        state = ListMoviesState(favoritesManager: favoritesManagerMock, movieProvider: movieProviderMock)
        state.delegate = delegateMock
    }
    
    func testDataFetchSuccess() {
        // arrange
        movieProviderMock.cachedMovies = [Movie(title: "Batman Begins", year: "2018", imdbId: "asdf", type: "Movie", poster: nil)]
        favoritesManagerMock.favoriteMovieId = "asdf"

        // act
        state.fetchInitialData()

        // assert
        XCTAssert(delegateMock.didUpdateMoviesWasCalled)
        XCTAssert(state.movies.count == 1)
        XCTAssert(state.movies.first?.fullTitle == "Batman Begins (2018)")
        XCTAssert(state.movies.first?.isFavorite == true)
    }

    func testDataFetchFailure() {
        // arrange
        movieProviderMock.cachedError = NSError(domain: "asdf", code: 999, userInfo: nil)

        // act
        state.fetchInitialData()

        // assert
        XCTAssert(delegateMock.didFailToFetchMoviesWasCalled)
    }

    func testToggleFavorite() {
        // arrange
        movieProviderMock.cachedMovies = [Movie(title: "Batman Begins", year: "2018", imdbId: "asdf", type: "Movie", poster: nil)]
        state.fetchInitialData()

        // act
        state.handleTap(at: 0)

        // assert
        XCTAssert(favoritesManagerMock.favoriteMovieId == "asdf")
        XCTAssert(state.movies.first?.isFavorite == true)
        XCTAssert(delegateMock.indexOfUpdatedMovie == 0)
    }
}

// Helpers

class FavoriteMoviesManagerMock: FavoriteMoviesManager {
    var favoriteMovieId: String?

    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovieId == movie.uid
    }

    func toggleIsFavorite(movie: Movie) {
        if favoriteMovieId == movie.uid {
            favoriteMovieId = nil
        } else {
            favoriteMovieId = movie.uid
        }
    }
}

class MovieProviderMock: MovieProvider {
    var cachedError: Error?
    var cachedMovies: [Movie] = []

    func fetchMovies(completionHandler: @escaping (Error?, [Movie]) -> Void) {
        completionHandler(cachedError, cachedMovies)
    }
}

class ListMoviesStateDelegateMock: ListMoviesStateDelegate {

    var didFailToFetchMoviesWasCalled = false
    func didFailToFetchMovies() {
        didFailToFetchMoviesWasCalled = true
    }

    var didUpdateMoviesWasCalled = false
    func didUpdateMovies() {
        didUpdateMoviesWasCalled = true
    }

    var indexOfUpdatedMovie: Int?
    func didUpdateMovie(at index: Int) {
        indexOfUpdatedMovie = index
    }
}

