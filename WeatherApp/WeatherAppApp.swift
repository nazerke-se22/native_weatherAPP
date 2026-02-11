import SwiftUI
import Firebase

@main
struct WeatherAppApp: App {

    init() {
        FirebaseApp.configure()

        let url = "https://myweatherapp-a2883-default-rtdb.europe-west1.firebasedatabase.app"
        Database.database(url: url)

        print("FIREBASE STARTED OK")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
