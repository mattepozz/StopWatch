import SwiftUI

struct ContentView: View {
    @StateObject private var store = StopwatchStore.shared

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Text(formatTime(store.elapsed))
                .font(.system(size: 90, weight: .thin, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal, 20)

            Spacer()

            HStack(spacing: 40) {
                Button(action: toggleStartStop) {
                    Image(systemName: store.isRunning ? "stop.fill" : "play.fill")
                        .font(.system(size: 40))
                        .frame(width: 100, height: 100)
                        .background(store.isRunning ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                        .foregroundStyle(store.isRunning ? .red : .green)
                        .clipShape(Circle())
                }

                if store.isRunning {
                    Button(action: restart) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 40))
                            .frame(width: 100, height: 100)
                            .background(Color.orange.opacity(0.2))
                            .foregroundStyle(.orange)
                            .clipShape(Circle())
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: store.isRunning)
            .padding(.bottom, 60)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            store.syncFromDefaults()
        }
        .onChange(of: store.isRunning) { _, isRunning in
            UIApplication.shared.isIdleTimerDisabled = isRunning
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = store.isRunning
        }
    }

    private func toggleStartStop() {
        if store.isRunning {
            triggerHaptic(.medium)
            store.stop()
        } else {
            triggerHaptic(.light)
            store.start()
        }
    }

    private func restart() {
        triggerHaptic(.light)
        store.restart()
    }

    private func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let centiseconds = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600

        if hours > 0 {
            return String(format: "%d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
        } else {
            return String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
        }
    }
}

#Preview {
    ContentView()
}
