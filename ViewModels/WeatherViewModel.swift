import Foundation
import SwiftUI
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {

    // MARK: - Search
    @Published var query: String = ""
    @Published var suggestions: [GeoResult] = []

    // MARK: - Weather
    @Published var selectedCityTitle: String = ""
    @Published var weather: ForecastResponse?

    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isOfflineMode: Bool = false

    // MARK: - Navigation
    @Published var showWeatherScreen: Bool = false
    @Published var showSettings: Bool = false

    // MARK: - Settings
    @AppStorage("temp_unit") private var unitRaw: String = TemperatureUnit.celsius.rawValue
    var unit: TemperatureUnit {
        get { TemperatureUnit(rawValue: unitRaw) ?? .celsius }
        set { unitRaw = newValue.rawValue }
    }

    private let repo = WeatherRepository()
    private let cache = CacheStore()

    // MARK: - Restore cache
    func restoreFromCacheOnLaunch() {
        if let cached = cache.load() {
            weather = cached.0
            selectedCityTitle = cached.1.cityTitle
            isOfflineMode = true
            showWeatherScreen = true
        }
    }

    // MARK: - Search city
    func searchCity() async {
        errorMessage = nil
        isOfflineMode = false

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            suggestions = []
            errorMessage = "Please enter a city name."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            suggestions = try await repo.searchCity(name: trimmed, language: "en")
        } catch {
            suggestions = []
            errorMessage = "Search failed."
        }
    }

    // MARK: - Select city
    func selectCity(_ city: GeoResult) async {

        selectedCityTitle = [city.name, city.admin1, city.country]
            .compactMap { $0 }
            .joined(separator: ", ")

        isLoading = true
        defer { isLoading = false }

        do {
            let res = try await repo.fetchWeather(lat: city.latitude, lon: city.longitude, unit: unit)
            weather = res
            cache.save(weather: res, cityTitle: selectedCityTitle, unit: unit)
            showWeatherScreen = true

        } catch {

            if let cached = cache.load() {
                weather = cached.0
                selectedCityTitle = cached.1.cityTitle
                isOfflineMode = true
                errorMessage = "Showing cached data (offline)."
                showWeatherScreen = true
            } else {
                errorMessage = "Failed to load weather."
            }
        }
    }

    func search(city: String) {

        Task {

            self.query = city

            do {
                let results = try await repo.searchCity(name: city, language: "en")

                if let first = results.first {
                    await selectCity(first)
                } else {
                    errorMessage = "City not found."
                }

            } catch {
                errorMessage = "Failed to load city."
            }
        }
    }

    // MARK: - Weather code
    func conditionText(from code: Int?) -> String {
        guard let code else { return "Unknown" }
        switch code {
        case 0: return "Clear"
        case 1, 2, 3: return "Cloudy"
        case 45, 48: return "Fog"
        case 51, 53, 55: return "Drizzle"
        case 61, 63, 65: return "Rain"
        case 71, 73, 75: return "Snow"
        case 80, 81, 82: return "Showers"
        case 95, 96, 99: return "Thunderstorm"
        default: return "Other"
        }
    }
}
