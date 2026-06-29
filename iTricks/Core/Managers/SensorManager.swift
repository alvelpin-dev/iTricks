import CoreMotion
import CoreLocation
import AVFoundation
import UIKit
import Combine

/// Acceso unificado a los sensores de movimiento, orientación y proximidad
/// del iPhone. Cada efecto se suscribe solo a lo que necesita y el manager
/// se encarga de arrancar/detener los sensores físicos para no gastar batería
/// de fondo cuando ningún efecto los está usando.
final class SensorManager: NSObject, ObservableObject {
    static let shared = SensorManager()

    // MARK: Motion (acelerómetro, giroscopio, actitud del dispositivo)

    private let motionManager = CMMotionManager()
    @Published private(set) var roll: Double = 0
    @Published private(set) var pitch: Double = 0
    @Published private(set) var rotationRate: Double = 0

    // MARK: Brújula

    private let locationManager = CLLocationManager()
    @Published private(set) var heading: Double = 0

    // MARK: Proximidad

    @Published private(set) var isClose = false

    // MARK: Detección de zarandeo (acelerómetro)

    /// Se dispara a `true` durante una fracción de segundo cuando se detecta
    /// un movimiento brusco (zarandeo o golpe seco), útil para disparar
    /// "tiradas" de dado o vanishes de moneda sincronizados con un gesto real.
    @Published private(set) var shakeDetected = false
    private var lastShakeTime = Date.distantPast

    // MARK: Nivel de micrófono

    private var audioRecorder: AVAudioRecorder?
    private var micTimer: Timer?
    /// Nivel de audio normalizado entre 0 y 1, actualizado varias veces por segundo.
    @Published private(set) var micLevel: Double = 0

    private override init() {
        super.init()
        locationManager.delegate = self
    }

    func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable, !motionManager.isDeviceMotionActive else { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            self.roll = motion.attitude.roll
            self.pitch = motion.attitude.pitch
            self.rotationRate = motion.rotationRate.z

            let acceleration = motion.userAcceleration
            let magnitude = sqrt(
                acceleration.x * acceleration.x +
                acceleration.y * acceleration.y +
                acceleration.z * acceleration.z
            )
            if magnitude > 1.6, Date().timeIntervalSince(self.lastShakeTime) > 0.6 {
                self.lastShakeTime = Date()
                self.shakeDetected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.shakeDetected = false
                }
            }
        }
    }

    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }

    func startHeadingUpdates() {
        guard CLLocationManager.headingAvailable() else { return }
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
    }

    func stopHeadingUpdates() {
        locationManager.stopUpdatingHeading()
    }

    func startProximityMonitoring() {
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(proximityChanged),
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil
        )
    }

    func stopProximityMonitoring() {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }

    @objc private func proximityChanged() {
        isClose = UIDevice.current.proximityState
    }

    // MARK: Linterna

    /// Controla la linterna real del dispositivo. Usada por efectos como
    /// el Destello Espiritista para codificar respuestas en parpadeos.
    func setTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = on ? .on : .off
        device.unlockForConfiguration()
    }

    func startMicMonitoring() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record)
        try? session.setActive(true)

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("itricks_mic_level.caf")
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        guard let recorder = try? AVAudioRecorder(url: url, settings: settings) else { return }
        recorder.isMeteringEnabled = true
        recorder.record()
        audioRecorder = recorder

        micTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 12.0, repeats: true) { [weak self] _ in
            guard let self, let recorder = self.audioRecorder else { return }
            recorder.updateMeters()
            let decibels = recorder.averagePower(forChannel: 0)
            let normalized = pow(10, decibels / 20)
            self.micLevel = min(1, max(0, Double(normalized) * 4))
        }
    }

    func stopMicMonitoring() {
        micTimer?.invalidate()
        micTimer = nil
        audioRecorder?.stop()
        audioRecorder = nil
        micLevel = 0
    }

    /// Detiene todos los sensores activos. Debe llamarse al salir de la
    /// vista del efecto para no dejar sensores corriendo en segundo plano.
    func stopAll() {
        stopMotionUpdates()
        stopHeadingUpdates()
        stopProximityMonitoring()
        stopMicMonitoring()
    }
}

extension SensorManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
    }
}
