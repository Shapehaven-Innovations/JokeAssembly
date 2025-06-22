// HomeView.swift
// Jokes – SmirkOS Shell w/ High-Contrast White Bubbles

import SwiftUI

struct HomeView: View {
    let joke: Joke

    @Binding var showPunchline: Bool
    @Binding var noiseEnabled: Bool
    @Binding var noiseIndex: Int

    let onRefresh: () -> Void
    let onReveal:  () -> Void
    let onFavorite: () -> Void
    let isFavorited: Bool

    let categories: [JokeViewModel.JokeType]
    @Binding var selectedCategory: JokeViewModel.JokeType

    @Binding var errorMessage: String?

    /// “Last login:” with current date/time
    private var lastLoginText: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MMM dd HH:mm:ss"
        return "Last login: \(fmt.string(from: Date())) on SmirkOS"
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // MARK: – Header
                VStack(spacing: 4) {
                    Text("Jokes Terminal")
                        .font(.system(.largeTitle, design: .monospaced))
                        .foregroundColor(K.Colors.accent)
                        .lineLimit(1)

                    Text(lastLoginText)
                        .font(.caption.monospaced())
                        .foregroundColor(.white)
                }
                .padding(.top, 16)

                // MARK: – Category Menu
                HStack {
                    Text("Category:")
                        .font(.subheadline.monospaced())
                        .foregroundColor(.white)

                    Menu {
                        ForEach(categories) { cat in
                            Button(cat.label) {
                                selectedCategory = cat
                                onRefresh()
                            }
                        }
                    } label: {
                        Text(selectedCategory.label)
                            .font(.subheadline.monospaced())
                            .foregroundColor(K.Colors.neonGreen)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(K.Colors.card)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(K.Colors.neonGreen, lineWidth: 1)
                            )
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Spacer()

                // MARK: – Q&A Bubbles
                VStack(spacing: 24) {
                    // Question Bubble
                    BubbleView(
                        attributedText: makeSetupAttributed(),
                        glowColor: K.Colors.neonBlue,
                        bgColor: Color.white.opacity(0.2)
                    )
                    .tilt()
                    .offset(y: showPunchline ? -16 : 0)
                    .animation(.easeOut(duration: 0.3), value: showPunchline)

                    // Answer Bubble
                    if showPunchline {
                        BubbleView(
                            attributedText: makeAnswerAttributed(),
                            glowColor: K.Colors.neonPurple,
                            bgColor: Color.white.opacity(0.2)
                        )
                        .transition(
                            .move(edge: .bottom)
                            .combined(with: .opacity)
                        )
                    }
                }
                .padding(.horizontal)

                Spacer()

                // MARK: – Controls
                HStack(spacing: 16) {
                    Button(action: onRefresh) {
                        Label("Next", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(NeonButtonStyle(neonColor: K.Colors.neonBlue))

                    Button(action: onReveal) {
                        Label("Reveal", systemImage: "eye.fill")
                    }
                    .buttonStyle(NeonButtonStyle(neonColor: K.Colors.neonPink))

                    Button(action: onFavorite) {
                        Image(systemName: isFavorited ? "star.fill" : "star")
                            .font(.title2)
                    }
                    .buttonStyle(NeonButtonStyle(neonColor: K.Colors.neonGreen))
                }
                .padding(.horizontal)

                // MARK: – Noise FX Toggle
                Toggle("Noise FX", isOn: $noiseEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: K.Colors.neonBlue))
                    .font(.subheadline.monospaced())
                    .foregroundColor(.white)
                    .padding(.top, 12)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 8)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(K.Colors.background)
            .alert(isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error")
                        .font(.headline.monospaced()),
                    message: Text(errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // MARK: – AttributedString Builders

    private func makeSetupAttributed() -> AttributedString {
        var attr = AttributedString("joke@SmirkOS ~ ")
        attr.foregroundColor = K.Colors.neonBlue

        var content = AttributedString(joke.setup)
        content.foregroundColor = .white

        attr.append(content)
        return attr
    }

    private func makeAnswerAttributed() -> AttributedString {
        var attr = AttributedString("answer@SmirkOS ~ ")
        attr.foregroundColor = .red

        var content = AttributedString(joke.punchline)
        content.foregroundColor = .white

        attr.append(content)
        return attr
    }
}

// MARK: – BubbleView Component

struct BubbleView: View {
    let attributedText: AttributedString
    let glowColor: Color
    let bgColor: Color

    var body: some View {
        Text(attributedText)
            .font(.title3.monospaced())
            .multilineTextAlignment(.leading)
            .padding(20)
            .background(bgColor)
            .cornerRadius(16)
            .shadow(color: glowColor.opacity(0.4), radius: 10, x: 0, y: 5)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            joke: .init(
                type: "general",
                setup: "Why did the developer go broke?",
                punchline: "Because they used up all their cache."
            ),
            showPunchline: .constant(true),
            noiseEnabled:   .constant(true),
            noiseIndex:     .constant(0),
            onRefresh: {},
            onReveal:  {},
            onFavorite: {},
            isFavorited: false,
            categories: JokeViewModel.JokeType.allCases,
            selectedCategory: .constant(.general),
            errorMessage: .constant(nil)
        )
        .preferredColorScheme(.dark)
    }
}

