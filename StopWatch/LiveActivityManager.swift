import ActivityKit
import Foundation

@MainActor
final class LiveActivityManager {
    static let shared = LiveActivityManager()

    private var currentActivity: Activity<StopwatchAttributes>?

    private init() {}

    func startActivity(startDate: Date) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        endActivity()

        let attributes = StopwatchAttributes()
        let state = StopwatchAttributes.ContentState(startDate: startDate)

        do {
            currentActivity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }

    func updateActivity(startDate: Date) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let state = StopwatchAttributes.ContentState(startDate: startDate)

        if let activity = currentActivity {
            Task {
                await activity.update(.init(state: state, staleDate: nil))
            }
        } else {
            startActivity(startDate: startDate)
        }
    }

    func endActivity() {
        guard let activity = currentActivity else { return }

        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        currentActivity = nil
    }

    func syncWithRunningActivities() {
        let activities = Activity<StopwatchAttributes>.activities
        currentActivity = activities.first
    }
}
