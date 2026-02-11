import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published var favorites: [FavoriteItem] = []

    init() {
        startListening()
    }

    private func startListening() {
        FirebaseService.shared.observeFavorites { items in
            DispatchQueue.main.async {
                self.favorites = items
            }
        }
    }

    // ADD TO FAVORITES
    func add(city: String, note: String, completion: @escaping (Bool) -> Void) {
        FirebaseService.shared.addFavorite(city: city, note: note) { success in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    // DELETE
    func delete(id: String) {
        FirebaseService.shared.deleteFavorite(id: id)
    }
}
