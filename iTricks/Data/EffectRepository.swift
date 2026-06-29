import Foundation

/// Registro central de todos los efectos disponibles en la app.
///
/// Para añadir un efecto nuevo:
/// 1. Crea un tipo que implemente `EffectModule` en `Data/Effects/`.
/// 2. Añade `EffectDescriptor(TuNuevoEfecto.self)` al array `allDescriptors`.
/// No es necesario tocar ningún otro archivo: listas, detalle, instrucciones
/// y práctica se generan automáticamente a partir de la metadata del efecto.
final class EffectRepository {
    static let shared = EffectRepository()

    let allDescriptors: [EffectDescriptor]

    private init() {
        allDescriptors = [
            EffectDescriptor(ThoughtDetectorEffect.self),
            EffectDescriptor(AnyCardEffect.self),
            EffectDescriptor(ParanormalDetectorEffect.self),
            EffectDescriptor(MagicCalculatorEffect.self),
            EffectDescriptor(PredictionSealedEffect.self),
            EffectDescriptor(LieDetectorEffect.self),
            EffectDescriptor(ImpossibleCoinEffect.self),
            EffectDescriptor(PhoneSpiritEffect.self),
            EffectDescriptor(MentalDiceEffect.self),
            EffectDescriptor(ObjectDetectorEffect.self),
            EffectDescriptor(MindReadingCameraEffect.self),
            EffectDescriptor(DestinyWheelEffect.self),
            EffectDescriptor(HauntedPhoneEffect.self),
            EffectDescriptor(AIWordGuesserEffect.self),
            EffectDescriptor(SiriPredictionEffect.self),
            EffectDescriptor(NumericMindReaderEffect.self),
            EffectDescriptor(LockScreenPredictionEffect.self),
            EffectDescriptor(SiriThePsychicEffect.self),
            EffectDescriptor(ToxicCalculatorEffect.self),
            EffectDescriptor(MusicalTelepathyEffect.self),
            EffectDescriptor(HapticLieDetectorShortcutEffect.self),
            EffectDescriptor(FutureSelfieEffect.self),
            EffectDescriptor(FrozenClockEffect.self),
            EffectDescriptor(MessageFromBeyondEffect.self),
            EffectDescriptor(CoinThroughScreenEffect.self),
            EffectDescriptor(ControlledVirtualDiceEffect.self),
            EffectDescriptor(BarcodeMindReaderEffect.self),
            EffectDescriptor(PropheticBatteryEffect.self),
            EffectDescriptor(ImpossibleWeatherEffect.self),
            EffectDescriptor(GhostInstagramPostEffect.self),
            EffectDescriptor(MindColorEffect.self),
            EffectDescriptor(PsychicPastAgendaEffect.self),
            EffectDescriptor(TelepathicUnlockEffect.self),
            EffectDescriptor(SpiritistFlashEffect.self),
            EffectDescriptor(ImpossibleWeightEffect.self)
        ]
    }

    func effects(in category: EffectCategory) -> [EffectDescriptor] {
        allDescriptors.filter { $0.info.category == category }
    }

    func descriptor(for id: String) -> EffectDescriptor? {
        allDescriptors.first { $0.info.id == id }
    }
}
