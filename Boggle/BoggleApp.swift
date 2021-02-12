import SwiftUI
import ComposableArchitecture
import BoggleEngine

@main
struct BoggleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: GameState(),
                    reducer: gameReducer,
                    environment: .live
                )
            )
        }
    }
}
