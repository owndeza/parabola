import SwiftUI

struct ParabolaBackground: View {
    let accent: Color
    let moves: Bool
    @State private var floating = false

    var body: some View {
        ZStack {
            Color(red: 0.025, green: 0.012, blue: 0.045)
            Circle().fill(accent.opacity(0.32)).frame(width: 380).blur(radius: 110).offset(x: 150, y: floating ? 310 : 230)
            Circle().fill(Color.purple.opacity(0.24)).frame(width: 330).blur(radius: 120).offset(x: -160, y: floating ? -280 : -210)
            Canvas { context, size in
                var path = Path()
                path.move(to: CGPoint(x: -30, y: size.height * 0.46))
                path.addQuadCurve(to: CGPoint(x: size.width + 40, y: size.height * 0.23), control: CGPoint(x: size.width * 0.52, y: size.height * 0.42))
                context.stroke(path, with: .linearGradient(Gradient(colors: [.clear, accent.opacity(0.8), .clear]), startPoint: .zero, endPoint: CGPoint(x: size.width, y: 0)), lineWidth: 1)
            }.blur(radius: 0.3)
        }
        .onAppear { guard moves else { return }; withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) { floating.toggle() } }
    }
}

struct ParabolaMark: View {
    var body: some View {
        GeometryReader { geo in
            Path { p in
                p.move(to: CGPoint(x: geo.size.width * 0.08, y: geo.size.height * 0.76))
                p.addQuadCurve(to: CGPoint(x: geo.size.width * 0.92, y: geo.size.height * 0.76), control: CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.02))
            }
            .stroke(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: geo.size.width * 0.14, lineCap: .round))
        }
    }
}

struct OrbitalHero: View {
    let accent: Color
    let glows: Bool
    @State private var spin = false

    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Ellipse().stroke(LinearGradient(colors: [.clear, accent.opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                    .frame(width: 250, height: 96).rotation3DEffect(.degrees(Double(52 + index * 34)), axis: (x: 1, y: 0.4, z: 0.4))
                    .rotationEffect(.degrees(spin ? Double(360 + index * 20) : Double(index * 20)))
            }
            Circle().fill(RadialGradient(colors: [.white, accent, .purple.opacity(0.7), .clear], center: .center, startRadius: 1, endRadius: 74)).frame(width: 148, height: 148)
                .shadow(color: glows ? accent.opacity(0.8) : .clear, radius: 34)
            Circle().stroke(.white.opacity(0.2), lineWidth: 1).frame(width: 78, height: 78)
        }
        .frame(maxWidth: .infinity).frame(height: 232)
        .onAppear { withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) { spin = true } }
    }
}

struct GlassCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View { content.padding(.vertical, 5).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous)).overlay(RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.12))) }
}

struct MenuRow: View {
    let icon: String, title: String, chevron: Bool, action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) { Image(systemName: icon).font(.system(size: 19, weight: .medium)).frame(width: 26); Text(title).font(.system(size: 16, weight: .medium)); Spacer(); if chevron { Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.38)) } }.padding(.horizontal, 20).frame(height: 63)
        }.buttonStyle(.plain)
    }
}

struct PressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View { configuration.label.scaleEffect(configuration.isPressed ? 0.975 : 1).opacity(configuration.isPressed ? 0.8 : 1).animation(.easeOut(duration: 0.15), value: configuration.isPressed) }
}
