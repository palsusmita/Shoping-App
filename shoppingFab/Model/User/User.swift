import Foundation

struct User: Codable {
    var id: String?
    var username: String?
    var email: String?
    var cart: [Int : Int]?
}
