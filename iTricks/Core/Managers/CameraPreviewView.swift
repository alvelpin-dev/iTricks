import SwiftUI
import AVFoundation

/// Vista de previsualización de cámara en vivo, reutilizada por los
/// efectos que se presentan como "visión artificial" (Detector de objetos,
/// Cámara que lee pensamientos, Foto del futuro, Lector de códigos de
/// barras mental). Soporta opcionalmente captura de fotos reales
/// (`AVCapturePhotoOutput`) y escaneo de códigos reales
/// (`AVCaptureMetadataOutput`); cada efecto activa solo lo que necesita.
final class CameraController: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private var hasConfigured = false
    private var capturesPhotos = false
    private var scansMetadata = false

    private let photoOutput = AVCapturePhotoOutput()
    private let metadataOutput = AVCaptureMetadataOutput()
    private var photoCompletion: ((UIImage?) -> Void)?

    /// Último tipo de símbolo detectado (QR, EAN-13, Code128…). Útil para
    /// efectos que reaccionan al tipo de código sin leer su contenido real.
    @Published var lastDetectedSymbology: AVMetadataObject.ObjectType?

    func start(capturesPhotos: Bool = false, scansMetadata: Bool = false) {
        self.capturesPhotos = capturesPhotos
        self.scansMetadata = scansMetadata

        guard !hasConfigured else {
            if !session.isRunning {
                DispatchQueue.global(qos: .userInitiated).async { self.session.startRunning() }
            }
            return
        }
        hasConfigured = true

        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted, let self else { return }
            self.configureSession()
        }
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
           let input = try? AVCaptureDeviceInput(device: device),
           session.canAddInput(input) {
            session.addInput(input)
        }

        if capturesPhotos, session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        if scansMetadata, session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .upce, .code128, .code39, .pdf417]
        }

        session.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async { self.session.startRunning() }
    }

    func stop() {
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { self.session.stopRunning() }
        }
    }

    /// Captura una foto real del feed actual de la cámara.
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        photoCompletion = completion
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            photoCompletion?(nil)
            photoCompletion = nil
            return
        }
        photoCompletion?(image)
        photoCompletion = nil
    }
}

extension CameraController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        lastDetectedSymbology = object.type
    }
}

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var controller: CameraController

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.previewLayer.session = controller.session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {}

    final class PreviewUIView: UIView {
        let previewLayer = AVCaptureVideoPreviewLayer()

        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(previewLayer)
        }

        required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer.frame = bounds
        }
    }
}
