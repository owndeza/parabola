import SwiftUI
import UIKit

enum ActivationStage: Equatable {
    case ready, preparing(Double), active

    var title: String {
        switch self {
        case .ready: "Ready to ascend"
        case .preparing: "Ascending…"
        case .active: "Welcome beyond"
        }
    }

    var detail: String {
        switch self {
        case .ready: "All compatibility checks passed."
        case .preparing: "Keep Parabola in the foreground."
        case .active: "Your environment is beautifully configured."
        }
    }
}

@MainActor
final class ParabolaModel: ObservableObject {
    @Published var stage: ActivationStage = .ready
    @Published var selectedTheme = 0
    @Published var haptics = true
    @Published var ambientMotion = true
    @Published var interfaceGlow = true

    let themes = [
        ThemePreset(name: "Nebula", caption: "Ultraviolet / Rose", colors: [.purple, .pink]),
        ThemePreset(name: "Aether", caption: "Azure / Cyan", colors: [.blue, .cyan]),
        ThemePreset(name: "Ember", caption: "Crimson / Gold", colors: [.red, .orange])
    ]

    var accent: Color { themes[selectedTheme].colors.last ?? .pink }

    func activate() async {
        guard stage == .ready else { return }
        for step in 1...20 {
            try? await Task.sleep(for: .milliseconds(95))
            stage = .preparing(Double(step) / 20)
        }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) { stage = .active }
        if haptics { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    }

    func restart() {
        withAnimation(.easeInOut(duration: 0.35)) { stage = .ready }
        if haptics { UIImpactFeedbackGenerator(style: .soft).impactOccurred() }
    }
}

struct ThemePreset: Identifiable {
    let id = UUID()
    let name: String
    let caption: String
    let colors: [Color]
}
