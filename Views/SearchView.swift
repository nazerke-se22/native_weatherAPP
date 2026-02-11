import SwiftUI

struct SearchView: View {

    @StateObject var vm = WeatherViewModel()
    @State private var showFavorites = false

    var body: some View {

        NavigationView {

            VStack(spacing: 16) {

                // HEADER
                HStack {
                    Text("Weather")
                        .font(.largeTitle)
                        .bold()

                    Spacer()

                    Button("Favorites") {
                        showFavorites = true
                    }
                }

                // SEARCH FIELD
                HStack {
                    TextField("Enter city...", text: $vm.query)
                        .textFieldStyle(.roundedBorder)

                    Button("Search") {
                        Task {
                            await vm.searchCity()
                        }
                    }
                }

                // ERROR
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                // LOADING
                if vm.isLoading {
                    ProgressView()
                }

                // CITY RESULTS
                List(vm.suggestions, id: \.id) { city in

                    Button {

                        Task {
                            await vm.selectCity(city)
                        }

                    } label: {

                        VStack(alignment: .leading) {
                            Text(city.name)
                                .font(.headline)

                            Text("\(city.admin1 ?? ""), \(city.country ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.plain)

                NavigationLink(
                    destination: WeatherView(vm: vm),
                    isActive: $vm.showWeatherScreen
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView()
        }
    }
}
