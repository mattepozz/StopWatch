import AppIntents
import Foundation

struct RestartStopwatchIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Restart Stopwatch"
    static var description = IntentDescription("Restarts the stopwatch from zero")

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            StopwatchStore.shared.restart()
        }
        return .result()
    }
}

struct StopStopwatchIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Stop Stopwatch"
    static var description = IntentDescription("Stops the stopwatch")

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            StopwatchStore.shared.stop()
        }
        return .result()
    }
}
