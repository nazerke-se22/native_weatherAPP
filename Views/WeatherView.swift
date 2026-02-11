import SwiftUI

struct WeatherView: View {

    @ObservedObject var vm: WeatherViewModel
    @StateObject private var favVM = FavoritesViewModel()

    @State private var showSuccess = false
    @State private var showError = false

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 16) {

                // CITY
                Text(vm.selectedCityTitle)
                    .font(.title2)
                    .bold()

                // CURRENT WEATHER
                if let current = vm.weather?.current {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Current")
                            .font(.headline)

                        Text("Temperature: \(current.temperature_2m ?? 0, specifier: "%.1f")°C")
                        Text("Feels like: \(current.apparent_temperature ?? 0, specifier: "%.1f")°C")
                        Text("Humidity: \(current.relative_humidity_2m ?? 0, specifier: "%.0f")%")
                        Text("Wind: \(current.wind_speed_10m ?? 0, specifier: "%.1f") m/s")
                        Text("Condition: \(vm.conditionText(from: current.weather_code))")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(12)
                }

                // ADD TO FAVORITES BUTTON
                Button {

                    favVM.add(city: vm.selectedCityTitle, note: "Added from weather") { success in
                        if success {
                            showSuccess = true
                        } else {
                            showError = true
                        }
                    }

                } label: {
                    Text("Add to favorites")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                // HOURLY FORECAST
                if let hourly = vm.weather?.hourly {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Next 24 hours")
                            .font(.headline)

                        ForEach(0..<min(24, hourly.time.count), id: \.self) { index in
                            HStack {
                                Text(hourly.time[index])
                                Spacer()
                                Text("\(hourly.temperature_2m?[index] ?? 0, specifier: "%.1f")°C")
                            }
                        }
                    }
                }
            }
            .padding()
        }

        // SUCCESS ALERT
        .alert("Success", isPresented: $showSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Successfully added to favorites")
        }

        // ERROR ALERT
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to add to Firebase")
        }

        .navigationTitle("Weather")
    }
}
