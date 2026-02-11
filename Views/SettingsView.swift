import SwiftUI
// Settings screen: temperature units.
struct SettingsView: View {
    @ObservedObject var vm: WeatherViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Units") {
                    Picker("Temperature", selection: Binding(
                        get: { vm.unit },
                        set: { vm.unit = $0 }
                    )) {
                        ForEach(TemperatureUnit.allCases) { u in
                            Text(u.title).tag(u)
                        }
                    }
                }

                Section {
                    Text("After changing units, select a city again to refresh the data.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}
