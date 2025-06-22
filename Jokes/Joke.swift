//  Joke.swift

// Joke.swift
import Foundation

struct Joke: Codable, Identifiable, Equatable {
    let id: UUID = .init()
    var type: String = ""
    var setup: String = ""
    var punchline: String = ""
    private enum CodingKeys: String, CodingKey {
        case type, setup, punchline
    }
}


