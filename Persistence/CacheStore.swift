import Foundation
// Stores last successful weather response in UserDefaults for offline mode.
final class CacheStore {
    private let weatherKey = "cached_weather_json"
    private let metaKey = "cached_weather_meta"

    struct Meta: Codable {
        let cityTitle: String
        let savedAt: Date
        let unitRaw: String
    }

    func save(weather: ForecastResponse, cityTitle: String, unit: TemperatureUnit) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if let data = try? encoder.encode(weather) {
            UserDefaults.standard.set(data, forKey: weatherKey)
        }

        let meta = Meta(cityTitle: cityTitle, savedAt: Date(), unitRaw: unit.rawValue)
        if let metaData = try? encoder.encode(meta) {
            UserDefaults.standard.set(metaData, forKey: metaKey)
        }
    }

    func load() -> (ForecastResponse, Meta)? {
        guard
            let data = UserDefaults.standard.data(forKey: weatherKey),
            let metaData = UserDefaults.standard.data(forKey: metaKey)
        else { return nil }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard
            let weather = try? decoder.decode(ForecastResponse.self, from: data),
            let meta = try? decoder.decode(Meta.self, from: metaData)
        else { return nil }

        return (weather, meta)
    }
}
