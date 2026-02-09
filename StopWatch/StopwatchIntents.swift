import AppIntents
import Foundation

struct RestartStopwatchIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Restart Stopwatch"
    static var description = IntentDescription("Restarts the stopwatch from zero")
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            StopwatchStore.shared.restart()
        }
        return .result()
    }
}
