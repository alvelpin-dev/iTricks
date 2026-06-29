# iTricks

App nativa de iOS (SwiftUI, MVVM) para magos y mentalistas profesionales. Diseño minimalista inspirado en Apple, arquitectura preparada para crecer a cientos de efectos.

## Requisitos

- macOS con Xcode 16+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- iOS 15.0+ como destino mínimo (compatible desde iPhone 11)

## Generar y abrir el proyecto

Este repositorio no incluye un `.xcodeproj` versionado a propósito (evita conflictos de merge en archivos binarios/XML generados). Se genera localmente con XcodeGen a partir de `iTricks/Project.yml`:

```bash
cd iTricks
xcodegen generate
open iTricks.xcodeproj
```

Compila y ejecuta con `Cmd+R` sobre un simulador o dispositivo físico (algunos efectos usan sensores reales — brújula, proximidad — que solo funcionan en dispositivo físico).

## Arquitectura

```
iTricks/
  App/                 Punto de entrada (iTricksApp, RootView)
  Core/
    Models/            Effect, EffectCategory, DifficultyLevel, EffectInstructions
    Managers/          HapticManager, SoundManager, SensorManager,
                        SecretInputManager, MagicEngine, PredictionEngine,
                        PerformanceModeManager
    Extensions/         Helpers de Color y View
  DesignSystem/        Theme, botones, badges, tarjetas reutilizables
  Features/
    Categories/        Pantalla principal de categorías
    EffectList/         Lista de efectos por categoría
    EffectDetail/        Pantalla de detalle (Comenzar/Instrucciones/Práctica/Ajustes)
    Instructions/        Pantalla de instrucciones genérica
    Practice/            Modo práctica paso a paso genérico
    SecretConfig/         Contenedor estándar de configuración secreta
    Settings/             Ajustes generales de la app (Modo Actuación)
  Data/
    EffectRepository.swift   Registro central de efectos
    Effects/                 Un archivo Swift por efecto
  Resources/
    Assets.xcassets
```

### Cómo añadir un efecto nuevo

1. Crea `Data/Effects/MiEfectoNuevo.swift`.
2. Define un `enum MiEfectoNuevo: EffectModule` con:
   - `static let info: EffectInfo` — metadata, instrucciones reales y pasos de práctica.
   - `static func performView() -> AnyView` — la vista que ve el mago al pulsar "Comenzar".
   - `static func settingsView() -> AnyView` — configuración secreta (usa `SecretConfigScreen` como contenedor).
   - `static func practiceView() -> AnyView` — normalmente basta con `PracticeView(info: info)`.
3. Registra el efecto añadiendo una línea en `Data/EffectRepository.swift`:
   ```swift
   EffectDescriptor(MiEfectoNuevo.self)
   ```
4. Listo. La lista de categorías, el detalle, las instrucciones y la práctica se generan automáticamente a partir de `info`.

### Modo Actuación

`PerformanceModeManager.shared` controla un estado global que oculta pestañas y controles de configuración para que la app parezca una aplicación normal delante del público. Se activa/desactiva desde Ajustes.

### Configuración secreta por efecto

Cada efecto puede revelar sus ajustes ocultos mediante gestos discretos gestionados por `SecretInputManager` (triple toque por defecto en una zona invisible de la pantalla). El público nunca ve un control visible para acceder a ellos.

## Efectos incluidos en esta versión

- Detector de pensamiento (Mentalismo)
- Adivina cualquier carta (Cartas)
- Detector paranormal (Paranormal)
- Calculadora mágica (Números)

El resto de efectos del briefing original (Predicción sellada, Detector de mentiras, Moneda imposible, Espíritu en el móvil, Dado mental, Detector de objetos, Cámara que lee pensamientos, Ruleta del destino, Móvil embrujado, IA que adivina palabras, Predicción con Siri) siguen la misma arquitectura `EffectModule` y se añaden de forma incremental siguiendo la guía anterior.
