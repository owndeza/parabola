import SwiftUI

struct ContentView: View {
    @StateObject private var model = ParabolaModel()
    @State private var sheet: AppSheet?

    var body: some View {
        ZStack {
            ParabolaBackground(accent: model.accent, moves: model.ambientMotion)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer(minLength: 64)
                    BrandHeader()
                    Spacer(minLength: 48)
                    OrbitalHero(accent: model.accent, glows: model.interfaceGlow)
                    statusCopy
                    actionCard
                    activeStatus
                    Spacer(minLength: 42)
                }
                .padding(.horizontal, 22)
            }
        }
        .ignoresSafeArea()
        .sheet(item: $sheet) { item in
            switch item {
            case .settings: SettingsView(model: model)
            case .themes: ThemesView(model: model)
            case .credits: CreditsView()
            }
        }
    }

    private var statusCopy: some View {
        VStack(spacing: 8) {
            Text(statusLabel).font(.system(size: 10, weight: .semibold)).tracking(2.2).foregroundStyle(model.accent)
            Text(model.stage.title).font(.system(size: 28, weight: .semibold, design: .rounded)).tracking(-1)
            Text(model.stage.detail).font(.subheadline).foregroundStyle(.white.opacity(0.52))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 22).padding(.bottom, 30)
        .contentTransition(.opacity)
    }

    private var statusLabel: String {
        if case .active = model.stage { return "PARABOLA ACTIVE" }
        return "SYSTEM STATUS"
    }

    private var actionCard: some View {
        GlassCard {
            VStack(spacing: 0) {
                MenuRow(icon: "gearshape", title: "Settings", chevron: true) { sheet = .settings }
                Divider().overlay(.white.opacity(0.11)).padding(.leading, 54)
                MenuRow(icon: "paintpalette", title: "Themes", chevron: true) { sheet = .themes }
                Divider().overlay(.white.opacity(0.11)).padding(.leading, 54)
                MenuRow(icon: "arrow.clockwise", title: "Restart SpringBoard", chevron: false) { model.restart() }
                Divider().overlay(.white.opacity(0.11)).padding(.leading, 54)
                MenuRow(icon: "info.circle", title: "Credits", chevron: true) { sheet = .credits }
            }
        }
    }

    private var activeStatus: some View {
        Button {
            switch model.stage {
            case .ready: Task { await model.activate() }
            case .active: model.restart()
            case .preparing: break
            }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(model.accent.opacity(0.2)).frame(width: 40, height: 40)
                    Image(systemName: buttonIcon).font(.system(size: 17, weight: .medium))
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(buttonTitle).font(.system(size: 16, weight: .semibold))
                    Text(buttonSubtitle).font(.caption).foregroundStyle(.white.opacity(0.48))
                }
                Spacer()
                if case .preparing(let progress) = model.stage {
                    ProgressView(value: progress).tint(model.accent).frame(width: 58)
                } else { Image(systemName: "arrow.up.right").foregroundStyle(.white.opacity(0.6)) }
            }
            .padding(17)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white.opacity(0.13)))
        }
        .buttonStyle(PressButtonStyle())
        .padding(.top, 18)
    }

    private var buttonTitle: String {
        switch model.stage { case .ready: "Activate Parabola"; case .preparing: "Preparing environment"; case .active: "Parabola is active" }
    }
    private var buttonSubtitle: String {
        switch model.stage { case .ready: "Touch to begin"; case .preparing(let value): "\(Int(value * 100))% complete"; case .active: "Touch to restore" }
    }
    private var buttonIcon: String {
        switch model.stage { case .ready: "lock.open"; case .preparing: "sparkles"; case .active: "checkmark" }
    }
}

private enum AppSheet: Int, Identifiable { case settings, themes, credits; var id: Int { rawValue } }

private struct BrandHeader: View {
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ParabolaMark().frame(width: 43, height: 43)
            VStack(alignment: .leading, spacing: 2) {
                Text("Parabola").font(.system(size: 30, weight: .bold, design: .rounded)).tracking(-1.5)
                Text("iOS 17.0 — 27.1").font(.caption).foregroundStyle(.white.opacity(0.52))
            }
            Spacer()
            Text("ONLINE").font(.system(size: 9, weight: .bold)).tracking(1.4).padding(.horizontal, 10).padding(.vertical, 7)
                .foregroundStyle(Color.green.opacity(0.9)).overlay(Capsule().stroke(Color.green.opacity(0.3)))
        }
    }
}
