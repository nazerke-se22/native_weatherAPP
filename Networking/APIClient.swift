import Foundation
// Errors that can happen during API calls.
enum APIError: LocalizedError {
    case invalidURL
    case requestFailed(Int)
    case decodingFailed
    case emptyResult
    case noInternet

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed(let code):
            return "Server error (HTTP \(code))."
        case .decodingFailed:
            return "Failed to decode server response."
        case .emptyResult:
            return "No results found."
        case .noInternet:
            return "No internet connection."
        }
    }
}
// Small URLSession wrapper using async/await + Codable.
final class APIClient {
    func fetch<T: Decodable>(_ type: T.Type, url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let http = response as? HTTPURLResponse else {
                throw APIError.requestFailed(-1)
            }
            guard (200...299).contains(http.statusCode) else {
                throw APIError.requestFailed(http.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        } catch {
            throw APIError.noInternet
        }
    }
}
