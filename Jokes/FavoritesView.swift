//FavoritesView.swift

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var jokeVM: JokeViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(jokeVM.favoriteJokes, id: \.setup) { joke in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Setup: \(joke.setup)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Punchline: \(joke.punchline)")
                            .font(.subheadline)
                            .foregroundColor(.accentColor)
                    }
                }
                .onDelete(perform: deleteJoke)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Favorite Jokes")
        }
        .navigationViewStyle(StackNavigationViewStyle()) 
    }
    
    private func deleteJoke(at offsets: IndexSet) {
        jokeVM.favoriteJokes.remove(atOffsets: offsets)
        jokeVM.saveFavorites()
    }
}
