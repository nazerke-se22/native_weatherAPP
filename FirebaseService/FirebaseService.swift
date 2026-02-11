import Foundation
import FirebaseAuth
import FirebaseDatabase

final class FirebaseService {

    static let shared = FirebaseService()
    private init() {}

    private var db: DatabaseReference {
        Database.database().reference()
    }

    // MARK: - AUTH

    func signIn() async throws -> String {
        let result = try await Auth.auth().signInAnonymously()
        return result.user.uid
    }

    var uid: String? {
        Auth.auth().currentUser?.uid
    }

    // MARK: - CRUD

    func addFavorite(city: String, note: String) {
        guard let uid else { return }

        let id = UUID().uuidString

        let data: [String: Any] = [
            "id": id,
            "city": city,
            "note": note,
            "createdAt": Date().timeIntervalSince1970,
            "createdBy": uid
        ]

        db.child("favorites").child(uid).child(id).setValue(data)
    }

    func deleteFavorite(id: String) {
        guard let uid else { return }
        db.child("favorites").child(uid).child(id).removeValue()
    }

    func observeFavorites(completion: @escaping ([FavoriteItem]) -> Void) {
        guard let uid else { return }

        db.child("favorites").child(uid).observe(.value) { snapshot in
            var items: [FavoriteItem] = []

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {

                    let item = FavoriteItem(
                        id: value["id"] as? String ?? "",
                        city: value["city"] as? String ?? "",
                        note: value["note"] as? String ?? ""
                    )

                    items.append(item)
                }
            }

            completion(items)
        }
    }
}
