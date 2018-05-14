import Foundation

struct Movie: Codable {
    let title: String
    let year: String
    let imdbId: String?
    let type: String
    let poster: URL?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbId
        case type = "Type"
        case poster = "Poster"
    }
}

extension Movie {
    var uid: String {
        return imdbId ?? "\(title)/\(year)/\(type)"
    }
}
