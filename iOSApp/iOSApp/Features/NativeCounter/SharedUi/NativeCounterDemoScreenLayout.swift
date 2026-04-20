import SwiftUI

enum NativeCounterDemoKind {
    case skie
    case plain

    fileprivate var accent: Color {
        switch self {
        case .skie:
            Color(red: 0.39, green: 0.27, blue: 0.85)
        case .plain:
            Color(red: 0.00, green: 0.55, blue: 0.52)
        }
    }

    fileprivate var badge: String {
        switch self {
        case .skie:
            "Skie interop"
        case .plain:
            "Plain Kotlin interop"
        }
    }

    fileprivate var symbolName: String {
        switch self {
        case .skie:
            "sparkles"
        case .plain:
            "link"
        }
    }
}

enum NativeCounterDemoPhase {
    case loading
    case success(count: Int, message: String)
}

struct NativeCounterDemoScreenLayout: View {
    let kind: NativeCounterDemoKind
    let interopExplainer: String
    let phase: NativeCounterDemoPhase
    let onIncrement: () -> Void
    let suspendButtonTitle: String
    let onRunSuspend: () -> Void
    let asyncSuspendResult: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header
                explainerCard
                mainSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background { backgroundGradient }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                kind.accent.opacity(0.18),
                Color(.systemGroupedBackground),
                Color(.systemGroupedBackground),
            ],
            startPoint: .topLeading,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var header: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 56, height: 56)
                    .shadow(color: kind.accent.opacity(0.28), radius: 14, y: 5)
                Image(systemName: kind.symbolName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(kind.accent)
                    .symbolRenderingMode(.hierarchical)
            }
            Text(NativeCounterStrings.screenTitle)
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)
            Text(kind.badge)
                .font(.caption.weight(.semibold))
                .foregroundStyle(kind.accent)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(
                    Capsule(style: .continuous)
                        .strokeBorder(kind.accent.opacity(0.45), lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity)
    }

    private var explainerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("How this screen talks to KMP", systemImage: "arrow.left.arrow.right.circle")
                .font(.subheadline.weight(.semibold))
            Text(interopExplainer)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        }
    }

    @ViewBuilder
    private var mainSection: some View {
        switch phase {
        case .loading:
            loadingCard
        case let .success(count, message):
            successContent(count: count, message: message)
        }
    }

    private var loadingCard: some View {
        VStack(spacing: 20) {
            ProgressView()
                .controlSize(.large)
                .tint(kind.accent)
            Text(NativeCounterStrings.loadingTitle)
                .font(.headline)
            Text(NativeCounterStrings.loadingHint)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .padding(.horizontal, 20)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(kind.accent.opacity(0.22), lineWidth: 1)
        }
    }

    private func successContent(count: Int, message: String) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("\(count)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.4, dampingFraction: 0.78), value: count)
                Text("Shared counter")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(kind.accent.opacity(0.38), lineWidth: 1)
            }

            Text(message)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)

            VStack(spacing: 12) {
                Button(action: onIncrement) {
                    Label(NativeCounterStrings.increment, systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(kind.accent)
                .controlSize(.large)

                Button(action: onRunSuspend) {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "bolt.horizontal.circle.fill")
                            .imageScale(.large)
                        Text(suspendButtonTitle)
                            .font(.subheadline.weight(.medium))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }

            if let line = asyncSuspendResult {
                suspendResultBanner(text: line)
            }
        }
    }

    private func suspendResultBanner(text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "text.bubble.fill")
                .font(.title3)
                .foregroundStyle(kind.accent)
            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(kind.accent.opacity(0.12))
        }
    }
}
