import SwiftUI

struct FavoritesView: View {

    @StateObject private var favVM = FavoritesViewModel()
    @StateObject private var weatherVM = WeatherViewModel()

    var body: some View {

        NavigationView {

            List {

                ForEach(favVM.favorites) { item in

                    NavigationLink {

                        WeatherView(vm: weatherVM)
                            .onAppear {
                                weatherVM.search(city: item.city)
                            }

                    } label: {

                        VStack(alignment: .leading) {

                            Text(item.city)
                                .font(.headline)

                            Text(item.note)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let item = favVM.favorites[index]
                        favVM.delete(id: item.id)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
