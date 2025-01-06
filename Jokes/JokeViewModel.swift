//  JokeViewModel.swift


import Foundation

@MainActor
class JokeViewModel: ObservableObject {
    @Published var joke = Joke()
    @Published var favoriteJokes: [Joke] = []
    
    var urlString = "https://joke.deno.dev"
    
    init() {
        loadFavorites() // Load any saved favorites from UserDefaults
    }
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not convert \(urlString) to a URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let jokes = try JSONDecoder().decode([Joke].self, from: data)
                joke = jokes.first ?? Joke()
                print("Setup: \(joke.setup)")
                print("Punchline: \(joke.punchline)")
            } catch {
                print("😡 JSON ERROR: Could not decode JSON data: \(error.localizedDescription)")
            }
        } catch {
            print("😡 ERROR: Could not get data from URL: \(urlString). \(error.localizedDescription)")
        }
    }
    
    // MARK: - Favorites Persistence
    
    func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: "favoriteJokes") else { return }
        do {
            let loadedJokes = try JSONDecoder().decode([Joke].self, from: data)
            favoriteJokes = loadedJokes
        } catch {
            print("Unable to decode favorite jokes: \(error.localizedDescription)")
        }
    }
    
    func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favoriteJokes)
            UserDefaults.standard.set(data, forKey: "favoriteJokes")
        } catch {
            print("Unable to encode favorite jokes: \(error.localizedDescription)")
        }
    }
    
    func addToFavorites(_ joke: Joke) {
        // Prevent duplicate entries
        if !favoriteJokes.contains(joke) {
            favoriteJokes.append(joke)
            saveFavorites()
            print("✅ Joke added to favorites.")
        } else {
            print("ℹ️ Joke already in favorites.")
        }
    }
}
