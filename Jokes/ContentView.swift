//
//  ContentView.swift
//  Jokes
//

import SwiftUI
import AVFAudio     // Still used for the playSound functionality

struct ContentView: View {
    
    enum JokeType: String, CaseIterable {
        case general, knock_knock, programming, anime, food, dad
    }
    
    @StateObject private var jokeVM = JokeViewModel()
    @State private var showPunchline = false
    @State private var selectedJoke = JokeType.general
    @State private var audioPlayer: AVAudioPlayer?
    @State private var soundNumber = 0
    
    // Use @AppStorage to automatically persist the sound setting
    @AppStorage("isSoundEnabled") private var isSoundEnabled: Bool = false
    
    @State private var showError = false
    
    let totalSounds = 25
    
    var body: some View {
        TabView {
            jokesHomeView
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            FavoritesView(jokeVM: jokeVM)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
        // No need for onChange as @AppStorage handles persistence
    }
    
    // MARK: - Home View
    private var jokesHomeView: some View {
        // Wrap the content in a GeometryReader for scale computation
        GeometryReader { geometry in
            let scaleFactor = min(geometry.size.width / 375, geometry.size.height / 667)
            // Use a ScrollView to allow pull-to-refresh
            ScrollView {
                VStack(alignment: .leading, spacing: scaledValue(17, scale: scaleFactor)) {
                    // Header
                    Text("Jokes! 😜")
                        .font(.system(size: scaledValue(32, scale: scaleFactor), weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(scaledValue(17, scale: scaleFactor))
                        .background(Color.red)
                        .cornerRadius(scaledValue(8, scale: scaleFactor))
                    
                    // Joke Content
                    VStack(alignment: .leading, spacing: scaledValue(17, scale: scaleFactor)) {
                        Text("Setup:")
                            .foregroundColor(.red)
                            .bold()
                            .font(.system(size: scaledValue(20, scale: scaleFactor)))
                        
                        Text(jokeVM.joke.setup)
                            .font(.system(size: scaledValue(18, scale: scaleFactor)))
                            .minimumScaleFactor(0.5)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Group {
                            Text("Punchline:")
                                .foregroundColor(.red)
                                .bold()
                                .font(.system(size: scaledValue(20, scale: scaleFactor)))
                                .opacity(showPunchline ? 1 : 0)
                            
                            Text(jokeVM.joke.punchline)
                                .font(.system(size: scaledValue(18, scale: scaleFactor)))
                                .minimumScaleFactor(0.5)
                                .fixedSize(horizontal: false, vertical: true)
                                .opacity(showPunchline ? 1 : 0)
                        }
                        .animation(.easeInOut(duration: 0.3), value: showPunchline)
                    }
                    .padding(.horizontal, scaledValue(17, scale: scaleFactor))
                    
                    Spacer(minLength: scaledValue(20, scale: scaleFactor))
                    
                    // Sound Toggle
                    Toggle("Enable Sound", isOn: $isSoundEnabled)
                        .padding(.horizontal, scaledValue(17, scale: scaleFactor))
                    
                    // Buttons Row - all the same size
                    HStack(spacing: 17) {
                        // 1) Get Joke
                        Button("Get Joke") {
                            fetchNewJoke()
                            withAnimation {
                                showPunchline = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .font(.system(size: scaledValue(16, scale: scaleFactor), weight: .bold))
                        .frame(maxWidth: .infinity)
                        
                        // 2) Punchline
                        Button("Punchline") {
                            if isSoundEnabled {
                                playSound(soundName: "\(soundNumber)")
                                soundNumber = (soundNumber + 1) % totalSounds
                            }
                            withAnimation(UIAccessibility.isReduceMotionEnabled ? nil : .easeInOut(duration: 0.3)) {
                                showPunchline = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .font(.system(size: scaledValue(16, scale: scaleFactor), weight: .bold))
                        .frame(maxWidth: .infinity)
                        
                        // 3) Star icon (blue)
                        Button {
                            jokeVM.addToFavorites(jokeVM.joke)
                        } label: {
                            Image(systemName: "star.fill")
                                .font(.title2)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.cyan)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, scaledValue(17, scale: scaleFactor))
                    .padding(.bottom, scaledValue(17, scale: scaleFactor))
                    
                    // Joke Type Picker
                    HStack {
                        Text("Joke Type:")
                            .bold()
                            .foregroundColor(.red)
                            .font(.system(size: scaledValue(18, scale: scaleFactor)))
                        
                        Spacer()
                        
                        Picker("", selection: $selectedJoke) {
                            ForEach(JokeType.allCases, id: \.self) { jokeType in
                                Text(formatJokeType(jokeType: jokeType))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: scaledValue(150, scale: scaleFactor))
                    }
                    .padding(.horizontal, scaledValue(17, scale: scaleFactor))
                    .padding(.bottom, scaledValue(17, scale: scaleFactor))
                }
                // Ensure the content fills the available height
                .frame(minHeight: geometry.size.height)
                .background(Color(UIColor.systemBackground))
                // Attach the alert to the inner view
                .alert("Error", isPresented: $showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Failed to fetch a new joke. Please check your internet connection.")
                }
            }
            // The refreshable modifier lets users pull down to fetch a new joke.
            .refreshable {
                fetchNewJoke()
                withAnimation {
                    showPunchline = false
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func scaledValue(_ value: CGFloat, scale: CGFloat) -> CGFloat {
        return value * scale
    }
    
    private func formatJokeType(jokeType: JokeType) -> String {
        jokeType == .knock_knock ? "knock-knock" : jokeType.rawValue
    }
    
    private func fetchNewJoke() {
        jokeVM.urlString = "https://joke.deno.dev/type/\(formatJokeType(jokeType: selectedJoke))/1"
        Task {
            await jokeVM.getData()
            
            // Show error if no joke was retrieved
            if jokeVM.joke.setup.isEmpty {
                showError = true
            }
        }
    }
    
    private func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName), isSoundEnabled else { return }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer?.play()
        } catch {
            print("Error creating audioPlayer: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
