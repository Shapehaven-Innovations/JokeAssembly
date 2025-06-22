
// SoundManager.swift
// Jokes – with Haptics and Asset‐Catalog Support

import Foundation
import AVFoundation
import UIKit

final class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    /// Plays the next indexed sound from your Assets catalog (Data Assets named "0", "1", …)
    /// or falls back to bundle files (mp3/m4a/wav). Wraps with haptic feedback.
    func playNext(enabled: Bool, currentIndex: inout Int) {
        guard enabled else { return }

        // 1. Haptic feedback
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let fileName = "\(currentIndex)"

        // 2. Try loading as a Data Asset
        if let dataAsset = NSDataAsset(name: fileName) {
            do {
                audioPlayer = try AVAudioPlayer(data: dataAsset.data)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                wrapIndex(&currentIndex)
                return
            } catch {
                print("🔈 Failed to play data-asset \(fileName): \(error.localizedDescription)")
            }
        }

        // 3. Fallback to bundle resources
        let exts = ["mp3", "m4a", "wav"]
        for ext in exts {
            if let url = Bundle.main.url(forResource: fileName, withExtension: ext) {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    wrapIndex(&currentIndex)
                    return
                } catch {
                    print("🔈 Failed to play \(fileName).\(ext): \(error.localizedDescription)")
                    return
                }
            }
        }

        // 4. Not found anywhere
        print("🔈 Sound not found in assets or bundle for index “\(fileName)”")
    }

    private func wrapIndex(_ idx: inout Int) {
        idx = (idx + 1) % K.totalSounds
    }
}
