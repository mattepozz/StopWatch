import Foundation
import Combine
import SwiftUI

@MainActor
final class StopwatchStore: ObservableObject {
    static let shared = StopwatchStore()

    private static let stateKey = "stopwatch_state"
    private static let appGroup = "group.com.mattepozz.StopWatch"

    @Published private(set) var state: StopwatchState = .stopped
    @Published private(set) var elapsed: TimeInterval = 0

    private var timer: Timer?
    private let defaults: UserDefaults

    var isRunning: Bool { state.isRunning }

    private init() {
        if let groupDefaults = UserDefaults(suiteName: Self.appGroup) {
            self.defaults = groupDefaults
        } else {
            self.defaults = .standard
        }
        restoreState()
        if isRunning {
            startTimer()
        }
    }

    func start() {
        let now = Date()
        state = .running(startDate: now)
        elapsed = 0
        persistState()
        startTimer()
        LiveActivityManager.shared.startActivity(startDate: now)
    }

    func stop() {
        state = .stopped
        elapsed = 0
        persistState()
        stopTimer()
        LiveActivityManager.shared.endActivity()
    }

    func restart() {
        let now = Date()
        state = .running(startDate: now)
        elapsed = 0
        persistState()
        if timer == nil {
            startTimer()
        }
        LiveActivityManager.shared.updateActivity(startDate: now)
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateElapsed()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateElapsed() {
        elapsed = state.elapsed()
    }

    private func persistState() {
        if let data = try? JSONEncoder().encode(state) {
            defaults.set(data, forKey: Self.stateKey)
            defaults.synchronize()
        }
    }

    private func restoreState() {
        guard let data = defaults.data(forKey: Self.stateKey),
              let savedState = try? JSONDecoder().decode(StopwatchState.self, from: data) else {
            return
        }
        state = savedState
        elapsed = state.elapsed()
    }

    func syncFromDefaults() {
        restoreState()
        if isRunning && timer == nil {
            startTimer()
        } else if !isRunning {
            stopTimer()
        }
    }
}
