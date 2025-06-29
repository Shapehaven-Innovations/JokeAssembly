
// JokeViewModel.swift

import SwiftUI

@MainActor
final class JokeViewModel: ObservableObject {
    @Published var current: Joke = .init()
    @Published var favorites: [Joke] = []
    @Published var errorMessage: String?
    @AppStorage("favoriteJokes") private var storedData: Data?

    var category: JokeType = .general

    init() {
        loadFavorites()
        fetchJoke()
    }

    func fetchJoke() {
        errorMessage = nil
        let url = K.apiBaseURL
            .appendingPathComponent("type")
            .appendingPathComponent(category.rawValue)
            .appendingPathComponent("1")
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let jokes = try JSONDecoder().decode([Joke].self, from: data)
                current = jokes.first ?? .init()
            } catch {
                errorMessage = "Could not load joke.\n\(error.localizedDescription)"
            }
        }
    }

    func toggleFavorite() {
        if favorites.contains(current) {
            favorites.removeAll { $0 == current }
        } else {
            favorites.append(current)
        }
        saveFavorites()
    }

    func isFavorited() -> Bool {
        favorites.contains(current)
    }

    private func loadFavorites() {
        guard let data = storedData,
              let jokes = try? JSONDecoder().decode([Joke].self, from: data)
        else { return }
        favorites = jokes
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            storedData = data
        }
    }

    // Add this function:
    func deleteFavorite(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
        saveFavorites()
    }

    enum JokeType: String, CaseIterable, Identifiable {
        case general, knock_knock = "knock-knock", programming, anime, food, dad
        var id: String { rawValue }
        var label: String { rawValue.capitalized.replacingOccurrences(of: "_", with: "-") }
    }
}
