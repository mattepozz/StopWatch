import SwiftUI

@main
struct StopWatchApp: App {
    init() {
        LiveActivityManager.shared.syncWithRunningActivities()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
