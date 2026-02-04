import AppIntents
import Foundation

struct RestartStopwatchIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Restart Stopwatch"
    static var description = IntentDescription("Restarts the stopwatch from zero")

    private static let stateKey = "stopwatch_state"
    private static let appGroup = "group.com.mattepozz.StopWatch"

    func perform() async throws -> some IntentResult {
        let now = Date()
        let newState = StopwatchState.running(startDate: now)

        if let defaults = UserDefaults(suiteName: Self.appGroup),
           let data = try? JSONEncoder().encode(newState) {
            defaults.set(data, forKey: Self.stateKey)
            defaults.synchronize()
        }

        await LiveActivityUpdater.updateActivity(startDate: now)

        return .result()
    }
}

struct StopStopwatchIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Stop Stopwatch"
    static var description = IntentDescription("Stops the stopwatch")

    private static let stateKey = "stopwatch_state"
    private static let appGroup = "group.com.mattepozz.StopWatch"

    func perform() async throws -> some IntentResult {
        let newState = StopwatchState.stopped

        if let defaults = UserDefaults(suiteName: Self.appGroup),
           let data = try? JSONEncoder().encode(newState) {
            defaults.set(data, forKey: Self.stateKey)
            defaults.synchronize()
        }

        await LiveActivityUpdater.endActivity()

        return .result()
    }
}
