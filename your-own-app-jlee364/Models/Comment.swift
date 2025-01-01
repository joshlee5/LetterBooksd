import Foundation

struct Comment: Hashable, Codable, Identifiable {
    var reviewId: String
    var id: String
    var user: String
    var date: Date
    var body: String
}
