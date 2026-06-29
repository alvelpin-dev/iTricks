import AVFoundation

/// Reproduce los sonidos de sistema y efectos de audio cortos usados durante
/// las actuaciones. Mantiene un único `AVAudioPlayer` vivo a la vez para
/// evitar fugas de memoria por instancias acumuladas.
final class SoundManager {
    static let shared = SoundManager()

    private var player: AVAudioPlayer?

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
    }

    enum EffectSound: String {
        case chime = "sound_chime"
        case whoosh = "sound_whoosh"
        case heartbeat = "sound_heartbeat"
        case staticNoise = "sound_static"
        case reveal = "sound_reveal"
    }

    /// Reproduce un sonido incluido en el bundle. Si el recurso no existe
    /// (por ejemplo, antes de añadir los assets de audio definitivos) la
    /// llamada es un no-op silencioso, nunca un crash.
    func play(_ sound: EffectSound, volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "caf")
            ?? Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
            return
        }
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.volume = volume
            newPlayer.prepareToPlay()
            newPlayer.play()
            player = newPlayer
        } catch {
            player = nil
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
