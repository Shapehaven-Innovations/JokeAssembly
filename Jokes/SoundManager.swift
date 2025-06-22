import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?
    private init() {}

    func playNext(enabled: Bool, currentIndex: inout Int) {
        guard enabled else { return }
        let name = "\(currentIndex)"
        if let asset = NSDataAsset(name: name) {
            do {
                player = try AVAudioPlayer(data: asset.data)
                player?.play()
                currentIndex = (currentIndex + 1) % K.totalSounds
            } catch {
                print("🔈 Sound error: \(error)")
            }
        }
    }
}
