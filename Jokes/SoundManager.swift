// SoundManager.swift
// Jokes – with Haptics

import Foundation
import AVFoundation
import UIKit

final class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playNext(enabled: Bool, currentIndex: inout Int) {
        guard enabled else { return }
        // Haptic tap
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let fileName = "\(currentIndex)"
        let extensions = ["mp3", "wav"]
        var soundURL: URL?
        for ext in extensions {
            if let url = Bundle.main.url(forResource: fileName, withExtension: ext) {
                soundURL = url; break
            }
        }
        guard let url = soundURL else {
            print("🔈 Sound file not found: \(fileName).(mp3|wav)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            currentIndex = (currentIndex + 1) % K.totalSounds
        } catch {
            print("🔈 Failed to play sound: \(error.localizedDescription)")
        }
    }
}

