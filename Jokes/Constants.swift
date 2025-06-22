//
//  K.swift
//  Jokes
//
//  Created by user on 6/21/25.
//


import SwiftUI

enum K {
    static let apiBaseURL = URL(string: "https://joke.deno.dev")!
    static let totalSounds = 25

    // smirkOS palette
    struct Colors {
        static let background = Color("smirkBackground")    // e.g. #0A0A0A
        static let neonGreen = Color("smirkNeonGreen")      // e.g. #39FF14
        static let neonPink = Color("smirkNeonPink")        // e.g. #FF2EC7
        static let accent = neonGreen
        static let card = Color("smirkCard")                // e.g. #1C1C1C
    }
}
