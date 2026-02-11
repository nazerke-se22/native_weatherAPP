import Foundation
// Temperature unit setting used by API and UI.
enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius, fahrenheit
    var id: String { rawValue }

    var title: String {
        switch self {
        case .celsius: return "Celsius (°C)"
        case .fahrenheit: return "Fahrenheit (°F)"
        }
    }

    var apiValue: String {
        switch self {
        case .celsius: return "celsius"
        case .fahrenheit: return "fahrenheit"
        }
    }

    var symbol: String { self == .celsius ? "°C" : "°F" }
}
// Builds URLs and loads data from Open-Meteo APIs.
final class WeatherRepository {
    private let api = APIClient()

    // City search (geocoding).
    func searchCity(name: String, language: String = "en") async throws -> [GeoResult] {
        var comps = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")
        comps?.queryItems = [
            .init(name: "name", value: name),
            .init(name: "count", value: "10"),
            .init(name: "language", value: language),
            .init(name: "format", value: "json")
        ]
        guard let url = comps?.url else { throw APIError.invalidURL }

        let res = try await api.fetch(GeocodingResponse.self, url: url)
        let results = res.results ?? []
        if results.isEmpty { throw APIError.emptyResult }
        return results
    }
    // Weather forecast: current + next 24h hourly + 3-day daily.
    func fetchWeather(lat: Double, lon: Double, unit: TemperatureUnit) async throws -> ForecastResponse {
        var comps = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        comps?.queryItems = [
            .init(name: "latitude", value: String(lat)),
            .init(name: "longitude", value: String(lon)),

            .init(name: "current", value: "temperature_2m,relative_humidity_2m,wind_speed_10m,apparent_temperature,weather_code"),

            .init(name: "hourly", value: "temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code"),
            .init(name: "forecast_hours", value: "24"),

            .init(name: "daily", value: "temperature_2m_max,temperature_2m_min,weather_code"),
            .init(name: "forecast_days", value: "3"),

            .init(name: "timezone", value: "auto"),
            .init(name: "temperature_unit", value: unit.apiValue)
        ]
        guard let url = comps?.url else { throw APIError.invalidURL }

        return try await api.fetch(ForecastResponse.self, url: url)
    }
}
