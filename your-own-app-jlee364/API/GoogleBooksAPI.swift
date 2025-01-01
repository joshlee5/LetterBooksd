import Foundation

let GB_ROOT = "https://www.googleapis.com/books/v1/volumes?q="
let apiKey = "AIzaSyA6NrkMrzKIwKbuKpa4y9D--00u6Tx4kCA"

enum GBAPIError: Error {
    case unsuccessfulDecode
}

// Getting unsuccessful decode
func getBookPage(query: String) async throws -> BookPage {
    guard let url = URL(string: "\(GB_ROOT)\(query)&key=\(apiKey)") else {
        fatalError("Should never happen, but just in case…URL didn’t work 😔")
    }
    
    print("About to call Url Session")

    let (data, _) = try await URLSession.shared.data(from: url)
    if let json = String(data: data, encoding: .utf8) {
        print(json)
    }
    print("Finished URL Session and about to start decoding")

    if let decodedPage = try? JSONDecoder().decode(BookPage.self, from: data) {
        print("Finished decodng")
        return decodedPage
    } else {
        throw GBAPIError.unsuccessfulDecode 
    }
}
