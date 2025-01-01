import Foundation

// Write struct for nested structs so that the smaller structs can be variables in nested structs
// Errors may come from values not being available

struct ImageLinks: Hashable, Codable {
    var smallThumbnail: String?
    var thumbnail: String?
}

struct VolumeInfo: Hashable, Codable {
    var title: String
    var authors: [String]?
    var publisher: String?
    var publishedDate: String?
    var description: String?
    var pageCount: Int?
    var imageLinks: ImageLinks?
}

struct Book: Identifiable, Hashable, Codable {
    var id: String?
    var volumeInfo: VolumeInfo?
}

struct BookPage: Hashable, Codable {
    var items: [Book]?
}
