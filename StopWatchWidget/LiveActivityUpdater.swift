import ActivityKit
import Foundation

enum LiveActivityUpdater {
    @MainActor
    static func updateActivity(startDate: Date) async {
        let state = StopwatchAttributes.ContentState(startDate: startDate)

        for activity in Activity<StopwatchAttributes>.activities {
            await activity.update(.init(state: state, staleDate: nil))
        }
    }

    @MainActor
    static func endActivity() async {
        for activity in Activity<StopwatchAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
