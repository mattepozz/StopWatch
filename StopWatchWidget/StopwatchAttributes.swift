import ActivityKit
import Foundation

struct StopwatchAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var startDate: Date
    }
}
