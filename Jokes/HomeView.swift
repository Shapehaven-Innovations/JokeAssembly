import SwiftUI

struct HomeView: View {
    let joke: Joke
    @Binding var showPunchline: Bool
    @Binding var soundEnabled: Bool
    @Binding var soundIndex: Int

    let onRefresh: () -> Void
    let onReveal: () -> Void
    let onFavorite: () -> Void
    let isFavorited: Bool

    let categories: [JokeViewModel.JokeType]
    @Binding var selectedCategory: JokeViewModel.JokeType

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 24) {
                    Text("🙂 Jokes Terminal")
                        .font(.system(.largeTitle, design: .monospaced))
                        .foregroundColor(K.Colors.neonGreen)
                        .padding(.top, 16)

                    VStack(spacing: 16) {
                        Group {
                            Text(joke.setup)
                                .font(.headline)
                                .multilineTextAlignment(.center)

                            if showPunchline {
                                Text(joke.punchline)
                                    .font(.subheadline)
                                    .foregroundColor(K.Colors.neonPink)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                        .padding()
                        .background(K.Colors.card)
                        .cornerRadius(12)
                        .shadow(color: K.Colors.neonGreen.opacity(0.2), radius: 10)
                    }
                    .padding(.horizontal)

                    Toggle("Sound FX", isOn: $soundEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: K.Colors.accent))
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        Button(action: onRefresh) {
                            Label("Next", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.borderedProminent)

                        Button(action: onReveal) {
                            Label("Reveal", systemImage: "eye.fill")
                        }
                        .buttonStyle(.borderedProminent)

                        Button(action: onFavorite) {
                            Image(systemName: isFavorited ? "star.fill" : "star")
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(isFavorited ? K.Colors.neonPink : .secondary)
                    }
                    .font(.headline)
                    .padding(.horizontal)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories) { cat in
                            Text(cat.label).tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)

                    Spacer(minLength: geo.safeAreaInsets.bottom + 20)
                }
                .refreshable { onRefresh() }
            }
            .background(K.Colors.background)
            .alert(item: Binding(
                get: { vmError() },
                set: { _ in }
            )) { msg in
                Alert(title: Text("Error"), message: Text(msg), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func vmError() -> String? {
        // This shim fetches errorMessage from parent VM via Binding if needed.
        nil
    }
}
