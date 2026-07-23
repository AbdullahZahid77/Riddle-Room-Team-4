import AVFoundation
import UIKit

// MARK: - Sound manager

class SoundManager {
    static let shared = SoundManager()

    private var bgPlayer: AVAudioPlayer?
    private var sfxPlayers: [String: AVAudioPlayer] = [:]

    private(set) var isMusicMuted: Bool = false
    private(set) var sfxVolume: Float = 0.8
    private(set) var musicVolume: Float = 0.5

    private init() {
        setupSession()
        preload()
    }

    // MARK: - Setup

    private func setupSession() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    private func preload() {
        let names = ["Click", "Hint", "Correct", "Incorrect", "Intro Sound"]
        for name in names {
            guard let url = Bundle.main.url(forResource: name, withExtension: "m4a") else { continue }
            let player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = sfxVolume
            sfxPlayers[name] = player
        }
    }

    // MARK: - Background music

    func startMusic() {
        if bgPlayer != nil {
            if !isMusicMuted { bgPlayer?.play() }
            return
        }
        guard let url = Bundle.main.url(forResource: "Background Music (Jazz)", withExtension: "m4a") else { return }
        bgPlayer = try? AVAudioPlayer(contentsOf: url)
        bgPlayer?.numberOfLoops = -1
        bgPlayer?.volume = musicVolume
        bgPlayer?.prepareToPlay()
        if !isMusicMuted { bgPlayer?.play() }
    }

    func setMusicMuted(_ muted: Bool) {
        isMusicMuted = muted
        if muted { bgPlayer?.pause() } else { bgPlayer?.play() }
    }

    func setMusicVolume(_ volume: Double) {
        musicVolume = Float(volume)
        bgPlayer?.volume = Float(volume)
    }

    // MARK: - Sound effects

    func play(_ name: String) {
        guard sfxVolume > 0 else { return }
        guard let player = sfxPlayers[name] else { return }
        player.volume = sfxVolume
        if player.isPlaying { player.currentTime = 0 }
        player.play()
    }

    func setSFXVolume(_ volume: Double) {
        sfxVolume = Float(volume)
        sfxPlayers.values.forEach { $0.volume = Float(volume) }
    }

    // MARK: - Global tap installation

    func installWindowTapSound() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .keyWindow else { return }

            let alreadyInstalled = window.gestureRecognizers?
                .contains(where: { $0 is GlobalTapSoundRecognizer }) ?? false
            guard !alreadyInstalled else { return }

            window.addGestureRecognizer(GlobalTapSoundRecognizer())
        }
    }
}

// MARK: - UIKit gesture recognizer for global tap sound

final class GlobalTapSoundRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
    private var touchStart: CGPoint?

    override init(target: Any?, action: Selector?) {
        super.init(target: nil, action: nil)
        cancelsTouchesInView = false
        delaysTouchesEnded = false
        delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        touchStart = touches.first?.location(in: view)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        defer { touchStart = nil; state = .failed }
        guard let s = touchStart, let t = touches.first else { return }
        let e = t.location(in: view)
        if hypot(e.x - s.x, e.y - s.y) < 15 {
            SoundManager.shared.play("Click")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = .cancelled
        touchStart = nil
    }

    // Always recognize alongside every other gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool { true }

    // Never block hit-testing
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool { true }
}
