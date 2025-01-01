import Foundation

struct Review: Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var user: String
    var date: Date
    var rating: String // Maybe Int?
    var body: String
}
