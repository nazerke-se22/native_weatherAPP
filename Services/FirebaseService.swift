import Foundation
import FirebaseAuth
import FirebaseDatabase

final class FirebaseService {

    static let shared = FirebaseService()
    private init() {}

    private let db = Database.database(
        url: "https://myweatherapp-a2883-default-rtdb.europe-west1.firebasedatabase.app"
    ).reference()

    // MARK: - AUTH

    func signInIfNeeded(completion: @escaping () -> Void) {

        if Auth.auth().currentUser != nil {
            completion()
            return
        }

        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print("AUTH ERROR:", error)
                return
            }

            print("SIGNED IN:", result?.user.uid ?? "")
            completion()
        }
    }

    private var uid: String? {
        Auth.auth().currentUser?.uid
    }

    // MARK: - ADD FAVORITE

    func addFavorite(city: String, note: String, completion: @escaping (Bool) -> Void) {

        signInIfNeeded {

            guard let uid = self.uid else {
                completion(false)
                return
            }

            let id = UUID().uuidString

            let data: [String: Any] = [
                "id": id,
                "city": city,
                "note": note,
                "createdAt": Date().timeIntervalSince1970
            ]

            self.db.child("favorites")
                .child(uid)
                .child(id)
                .setValue(data) { error, _ in

                    if let error = error {
                        print("FIREBASE WRITE ERROR:", error)
                        completion(false)
                        return
                    }

                    print("ADDED TO FIREBASE")
                    completion(true)
                }
        }
    }

    // MARK: - OBSERVE FAVORITES

    func observeFavorites(completion: @escaping ([FavoriteItem]) -> Void) {

        signInIfNeeded {

            guard let uid = self.uid else { return }

            self.db.child("favorites")
                .child(uid)
                .observe(.value) { snapshot in

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

    // MARK: - DELETE

    func deleteFavorite(id: String) {
        guard let uid else { return }
        db.child("favorites").child(uid).child(id).removeValue()
    }
}
