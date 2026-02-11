import Foundation
// Forecast API response (Open-Meteo).
struct ForecastResponse: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String

    let current: CurrentWeather?
    let hourly: HourlyWeather?
    let daily: DailyWeather?
}
// Current weather block.
struct CurrentWeather: Codable {
    let time: String
    let temperature_2m: Double?
    let relative_humidity_2m: Double?
    let wind_speed_10m: Double?
    let apparent_temperature: Double?
    let weather_code: Int?
}
// Hourly forecast block.
struct HourlyWeather: Codable {
    let time: [String]
    let temperature_2m: [Double]?
    let relative_humidity_2m: [Double]?
    let wind_speed_10m: [Double]?
    let weather_code: [Int]?
}
// Daily forecast block.
struct DailyWeather: Codable {
    let time: [String]
    let temperature_2m_max: [Double]?
    let temperature_2m_min: [Double]?
    let weather_code: [Int]?
}
