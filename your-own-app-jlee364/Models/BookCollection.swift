import Foundation

struct BookCollection: Hashable, Codable, Identifiable {
    var id: String
    var user: String
    var name: String
    var bookIds: Array<String>
}
