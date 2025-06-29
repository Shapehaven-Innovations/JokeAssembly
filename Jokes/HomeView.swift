// HomeView.swift
// Jokes – SmirkOS Shell w/ Slower, Resetting Pulse on New Questions (iOS 17+)

import SwiftUI

struct HomeView: View {
    let joke: Joke
    @Binding var showPunchline: Bool
    @Binding var noiseEnabled: Bool
    @Binding var noiseIndex: Int
    let onRefresh: () -> Void
    let onReveal: () -> Void
    let onFavorite: () -> Void
    let isFavorited: Bool
    let categories: [JokeViewModel.JokeType]
    @Binding var selectedCategory: JokeViewModel.JokeType
    @Binding var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 4) {
                Text("Jokes Terminal")
                    .font(.system(.largeTitle, design: .monospaced))
                    .foregroundColor(.green)
                    .lineLimit(1)
                Text("Last login: \(Date().formatted()) on SmirkOS")
                    .font(.caption.monospaced())
                    .foregroundColor(.white)
            }
            .padding(.top, 16)

            // Category Menu
            HStack {
                Text("Category:")
                    .font(.subheadline.monospaced())
                    .foregroundColor(.white)
                Menu {
                    ForEach(categories) { cat in
                        Button(cat.label) { selectedCategory = cat }
                    }
                } label: {
                    Text(selectedCategory.label)
                        .font(.subheadline.monospaced())
                        .foregroundColor(.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 1)
                        )
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)

            // Inline Native Ad
            NativeInlineAdView(adUnitID: "ca-app-pub-9596111320016039/4980818149")
                .frame(height: 100)
                .padding(.vertical, 8)

            Spacer()

            // Joke Question
            VStack(spacing: 24) {
                Text("joke@SmirkOS ~ \(joke.setup)")
                    .font(.title3.monospaced())
                    .foregroundColor(.cyan)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(16)
                if showPunchline {
                    Text("answer@SmirkOS ~ \(joke.punchline)")
                        .font(.title3.monospaced())
                        .foregroundColor(.purple)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal)
            .onTapGesture { onReveal() }

            Spacer()

            // Actions
            HStack(spacing: 20) {
                Button(action: onRefresh) {
                    Label("New Joke", systemImage: "arrow.clockwise.circle.fill")
                }
                .buttonStyle(NeonButtonStyle(neonColor: .cyan))

                Button(action: onFavorite) {
                    Label(isFavorited ? "Unfavorite" : "Favorite", systemImage: isFavorited ? "star.fill" : "star")
                }
                .buttonStyle(NeonButtonStyle(neonColor: .yellow))
            }
            .padding(.bottom, 16)
        }
        .background(Color.black.ignoresSafeArea())
        .alert(isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

