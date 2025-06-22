
// Constants.swift
// Jokes – SmirkOS Refactor
import SwiftUI

enum K {
    static let apiBaseURL = URL(string: "https://joke.deno.dev")!
    static let totalSounds  = 25

    struct Colors {
        static let background = Color.black
        static let accent     = Color.green.opacity(0.8)
        static let card       = Color(.secondarySystemBackground).opacity(0.6)
        // Neon palette
        static let neonPink   = Color(red: 1.0, green: 0.0, blue: 1.0)
        static let neonGreen  = Color(red: 0.22, green: 1.0, blue: 0.08)
        static let neonBlue   = Color(red: 0.0, green: 1.0, blue: 1.0)
        static let neonPurple = Color(red: 0.63, green: 0.13, blue: 0.94)
    }
}
