import Foundation

struct OMDBSearchResponse<T: Codable>: Codable {
    let search: [T]

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
