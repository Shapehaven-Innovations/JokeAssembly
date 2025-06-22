

// UIComponents.swift
// SmirkOS UI Kit
import SwiftUI

// MARK: – Neon Button
struct NeonButtonStyle: ButtonStyle {
    var neonColor: Color = K.Colors.neonGreen
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.monospaced())
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(K.Colors.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(neonColor, lineWidth: 2)
                    .shadow(color: neonColor.opacity(configuration.isPressed ? 0.9 : 0.6),
                            radius: configuration.isPressed ? 20 : 10)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: – Tilt Effect
struct TiltEffect: ViewModifier {
    @GestureState private var drag = CGSize.zero
    func body(content: Content) -> some View {
        let angleX = Double(drag.height / 10)
        let angleY = Double(-drag.width / 10)
        return content
            .rotation3DEffect(.degrees(angleX), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.degrees(angleY), axis: (x: 0, y: 1, z: 0))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($drag) { value, state, _ in
                        state = value.translation
                    }
            )
    }
}
extension View {
    func tilt() -> some View { modifier(TiltEffect()) }
}

// MARK: – Animated Neon Background
struct AnimatedBackground: View {
    @State private var animate = false
    var body: some View {
        AngularGradient(
            gradient: Gradient(colors: [
                K.Colors.neonPink,
                K.Colors.neonBlue,
                K.Colors.neonGreen,
                K.Colors.neonPurple
            ]),
            center: .center
        )
        .ignoresSafeArea()
        .hueRotation(.degrees(animate ? 360 : 0))
        .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: animate)
        .onAppear { animate = true }
    }
}

// MARK: – Retro Window Frame
struct AppWindow<Content: View>: View {
    let title: String
    let content: Content
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title; self.content = content()
    }
    var body: some View {
        VStack(spacing: 0) {
            // Title bar
            HStack(spacing: 8) {
                Circle().fill(Color.red).frame(width:12, height:12)
                Circle().fill(Color.yellow).frame(width:12, height:12)
                Circle().fill(Color.green).frame(width:12, height:12)
                Text(title)
                    .font(.caption.monospaced())
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                Spacer()
            }
            .padding(8)
            .background(Color.black.opacity(0.6))

            // Content area
            content
                .background(K.Colors.background.opacity(0.8))
                .cornerRadius(6)
                .padding(6)
        }
        .background(Color.black.opacity(0.4))
        .cornerRadius(8)
        .padding(4)
    }
}
