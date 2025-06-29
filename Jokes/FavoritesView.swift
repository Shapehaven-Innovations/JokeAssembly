import SwiftUI

struct FavoritesView: View {
    let favorites: [Joke]
    let onDelete: (IndexSet) -> Void  // Accept IndexSet

    init(favorites: [Joke], onDelete: @escaping (IndexSet) -> Void) {
        self.favorites = favorites
        self.onDelete = onDelete

        // UINavigationBar styling as before...
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var body: some View {
        NavigationView {
            ZStack {
                K.Colors.background.opacity(0.8).ignoresSafeArea()

                if favorites.isEmpty {
                    Text("No favorites yet.\nTap ⭐️ on a joke to save it.")
                        .multilineTextAlignment(.center)
                        .font(.headline.monospaced())
                        .foregroundColor(K.Colors.neonPurple)
                        .padding()
                } else {
                    List {
                        ForEach(favorites) { joke in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(joke.setup)
                                    .font(.headline.monospaced())
                                    .foregroundColor(.white)

                                Text(joke.punchline)
                                    .font(.subheadline.monospaced())
                                    .foregroundColor(K.Colors.neonPink)
                            }
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(K.Colors.accent, lineWidth: 1)
                            )
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: onDelete) // Correct signature
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Favorites")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(
            favorites: [
                Joke(type: "general", setup: "Why do wizards clean their teeth three times a day?", punchline: "To prevent bat breath!"),
                Joke(type: "dad", setup: "I'm reading a book on anti-gravity…", punchline: "It's impossible to put down!")
            ],
            onDelete: { _ in }
        )
        .preferredColorScheme(.dark)
    }
}

