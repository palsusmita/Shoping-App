import Foundation

struct ProductData: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: String
    let category: String
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
