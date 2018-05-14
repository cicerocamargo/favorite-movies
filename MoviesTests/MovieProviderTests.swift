import XCTest
import OHHTTPStubs
@testable import Movies

class MovieProviderTests: XCTestCase {

    let provider = OMDBMovieProvider()

    func testSuccedsToParseGoodData() {

        stub(condition: isHost("www.omdbapi.com"), response: { _ in
            let response = """
{"Search":[{"Title":"Batman Begins","Year":"2005","imdbID":"tt0372784","Type":"movie","Poster":"https://ia.media-imdb.com/images/M/MV5BYzc4ODgyZmYtMGFkZC00NGQyLWJiMDItMmFmNjJiZjcxYzVmXkEyXkFqcGdeQXVyNDYyMDk5MTU@._V1_SX300.jpg"},{"Title":"Batman v Superman: Dawn of Justice","Year":"2016","imdbID":"tt2975590","Type":"movie","Poster":"https://ia.media-imdb.com/images/M/MV5BYThjYzcyYzItNTVjNy00NDk0LTgwMWQtYjMwNmNlNWJhMzMyXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"}]}
"""
            return OHHTTPStubsResponse(data: response.data(using: .utf8)!, statusCode:200, headers:nil)
        })

        let _expectation = expectation(description: "will find expected movies")
        provider.fetchMovies(completionHandler: { error, movies in
            if error == nil && movies.count == 2 {
                _expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1.0)
    }

    func testFailsToParseEmptyResponse() {

        stub(condition: isHost("www.omdbapi.com"), response: { _ in
            return OHHTTPStubsResponse(data: "".data(using: .utf8)!, statusCode:200, headers:nil)
        })

        let _expectation = expectation(description: "will find an error")
        provider.fetchMovies(completionHandler: { error, movies in
            if error != nil {
                _expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1.0)
    }

    func testFailsToParseResponseMissingRequiredData() {
        stub(condition: isHost("www.omdbapi.com"), response: { _ in
            let response = """
{"Search":[{"Year":"2005","imdbID":"tt0372784","Type":"movie"}]}
"""
            return OHHTTPStubsResponse(data: response.data(using: .utf8)!, statusCode:200, headers:nil)
        })

        let _expectation = expectation(description: "will find expected movies")
        provider.fetchMovies(completionHandler: { error, movies in
            if error != nil {
                _expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1.0)

    }
}
