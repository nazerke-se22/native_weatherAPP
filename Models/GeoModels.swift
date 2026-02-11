import Foundation
// Geocoding API response (Open-Meteo).
struct GeocodingResponse: Codable {
    let results: [GeoResult]?
}

// Single city result from geocoding.
struct GeoResult: Codable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
}
