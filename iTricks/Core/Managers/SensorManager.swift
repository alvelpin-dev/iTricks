import CoreMotion
import CoreLocation
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

    /// Detiene todos los sensores activos. Debe llamarse al salir de la
    /// vista del efecto para no dejar sensores corriendo en segundo plano.
    func stopAll() {
        stopMotionUpdates()
        stopHeadingUpdates()
        stopProximityMonitoring()
    }
}

extension SensorManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
    }
}
