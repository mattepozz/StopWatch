import Foundation

enum StopwatchState: Codable, Equatable {
    case running(startDate: Date)
    case stopped

    var isRunning: Bool {
        if case .running = self { return true }
        return false
    }

    var startDate: Date? {
        if case .running(let date) = self { return date }
        return nil
    }

    func elapsed(at now: Date = Date()) -> TimeInterval {
        switch self {
        case .running(let startDate):
            return max(0, now.timeIntervalSince(startDate))
        case .stopped:
            return 0
        }
    }
}
