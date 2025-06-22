// ContentView.swift
// Jokes – SmirkOS Shell (w/ Noise FX)

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = JokeViewModel()

    /// Now controls your “Noise FX” (was soundEnabled)
    @AppStorage("noiseEnabled") private var noiseEnabled = true
    @State private var noiseIndex = 0
    @State private var showPunchline = false

    var body: some View {
        ZStack {
            AnimatedBackground()

            TabView {
                AppWindow(title: "SmirkOS — Home") {
                    HomeView(
                        joke: vm.current,
                        showPunchline: $showPunchline,
                        noiseEnabled: $noiseEnabled,
                        noiseIndex: $noiseIndex,
                        onRefresh: {
                            showPunchline = false
                            vm.fetchJoke()
                        },
                        onReveal: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                showPunchline = true
                            }
                            SoundManager.shared.playNext(
                                enabled: noiseEnabled,
                                currentIndex: &noiseIndex
                            )
                        },
                        onFavorite: vm.toggleFavorite,
                        isFavorited: vm.isFavorited(),
                        categories: JokeViewModel.JokeType.allCases,
                        selectedCategory: $vm.category,
                        errorMessage: $vm.errorMessage
                    )
                }
                .tabItem {
                    Label("Home", systemImage: "play.rectangle.fill")
                }

                AppWindow(title: "SmirkOS — Favorites") {
                    FavoritesView(
                        favorites: vm.favorites,
                        onDelete: vm.toggleFavorite
                    )
                }
                .tabItem {
                    Label("Stars", systemImage: "star.circle.fill")
                }
            }
            .accentColor(K.Colors.accent)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

