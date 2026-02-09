import ActivityKit
import SwiftUI
import WidgetKit

struct StopWatchLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StopwatchAttributes.self) { context in
            LockScreenView(startDate: context.state.startDate)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    HStack(alignment: .center) {
                        Text(timerInterval: context.state.startDate...Date.distantFuture, countsDown: false)
                            .font(.system(size: 50, weight: .thin, design: .rounded))
                            .monospacedDigit()
                        Spacer()
                        Button(intent: RestartStopwatchIntent()) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 50, height: 50)
                                .background(.orange)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 10)
                }
            } compactLeading: {
                Image(systemName: "stopwatch.fill")
                    .foregroundStyle(.orange)
            } compactTrailing: {
                Text(timerInterval: context.state.startDate...Date.distantFuture, countsDown: false)
                    .monospacedDigit()
                    .frame(width: 50)
            } minimal: {
                Image(systemName: "stopwatch.fill")
                    .foregroundStyle(.orange)
            }
        }
    }
}

struct LockScreenView: View {
    let startDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Stopwatch")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack {
                Text(timerInterval: startDate...Date.distantFuture, countsDown: false)
                    .font(.system(size: 60, weight: .thin, design: .rounded))
                    .monospacedDigit()
                Spacer()
                Button(intent: RestartStopwatchIntent()) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 60)
                        .background(.orange)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 24)
        .activityBackgroundTint(.black.opacity(0.8))
    }
}

#Preview("Lock Screen", as: .content, using: StopwatchAttributes()) {
    StopWatchLiveActivity()
} contentStates: {
    StopwatchAttributes.ContentState(startDate: Date())
}
