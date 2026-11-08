import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: ParabolaModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section("Experience") {
                    Toggle("Haptic feedback", isOn: $model.haptics)
                    Toggle("Ambient motion", isOn: $model.ambientMotion)
                    Toggle("Interface glow", isOn: $model.interfaceGlow)
                }
                Section("Environment") {
                    LabeledContent("Device", value: "iPhone")
                    LabeledContent("System", value: "iOS 17.0+")
                    LabeledContent("Build", value: "Parabola 1.0")
                }
            }
            .tint(model.accent).navigationTitle("Settings")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }.presentationDetents([.medium, .large]).presentationDragIndicator(.visible)
    }
}

struct ThemesView: View {
    @ObservedObject var model: ParabolaModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(Array(model.themes.enumerated()), id: \.element.id) { index, theme in
                        Button {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { model.selectedTheme = index }
                            if model.haptics { UISelectionFeedbackGenerator().selectionChanged() }
                        } label: {
                            HStack(spacing: 16) {
                                RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: theme.colors, startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 74, height: 74).overlay(ParabolaMark().padding(19))
                                VStack(alignment: .leading, spacing: 5) { Text(theme.name).font(.headline); Text(theme.caption).font(.caption).foregroundStyle(.secondary) }
                                Spacer(); Image(systemName: model.selectedTheme == index ? "checkmark.circle.fill" : "circle").font(.title2).foregroundStyle(model.selectedTheme == index ? model.accent : .secondary)
                            }.padding(12).background(.thinMaterial, in: RoundedRectangle(cornerRadius: 23))
                        }.buttonStyle(.plain)
                    }
                }.padding()
            }.navigationTitle("Themes").toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }.presentationDetents([.medium, .large]).presentationDragIndicator(.visible)
    }
}

struct CreditsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                ParabolaMark().frame(width: 90, height: 90)
                Text("Parabola").font(.system(size: 36, weight: .bold, design: .rounded)).tracking(-1.5)
                Text("Designed by landengo & nacist").foregroundStyle(.secondary)
                Text("Version 1.0.0 · Build 1").font(.caption).foregroundStyle(.tertiary)
                Spacer()
            }.padding(.top, 60).navigationTitle("Credits").toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }.presentationDetents([.medium]).presentationDragIndicator(.visible)
    }
}
