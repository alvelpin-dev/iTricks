# iTricks

App nativa de iOS (SwiftUI, MVVM) para magos y mentalistas profesionales. Diseño minimalista inspirado en Apple, arquitectura preparada para crecer a cientos de efectos.

## Requisitos

- macOS con Xcode 16+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- iOS 16.0+ como destino mínimo (compatible desde iPhone 11, que soporta hasta iOS 18)

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

- Detector de pensamiento (Mentalismo) — fuerza matemática (raíz digital de 9)
- Predicción sellada (Mentalismo) — equívoco de 4 opciones
- Adivina cualquier carta (Cartas) — seguimiento de cortes completos
- Detector paranormal (Paranormal) — magnetómetro real + control oculto
- Detector de mentiras (Paranormal) — nivel de micrófono real + control oculto
- Espíritu en el móvil (Paranormal) — vibración patrón que desplaza el teléfono
- Móvil embrujado (Paranormal) — sensor de proximidad real
- Calculadora mágica (Números) — propiedad matemática del 1089
- Dado mental (Números) — zarandeo real (acelerómetro) + resultado forzado
- Ruleta del destino (Números) — giro real, ángulo final forzado
- Detector de objetos (Tecnología) — cámara real + control oculto
- Cámara que lee pensamientos (Tecnología) — cámara real + fuerza matemática
- IA que adivina palabras (Tecnología) — equívoco de 4 opciones
- Predicción con Siri (Tecnología) — guía de Atajos de Siri reales
- Moneda imposible (Herramientas) — detección de gesto (acelerómetro) sincronizada con un vanish real

Los 15 efectos del briefing original están implementados siguiendo la misma arquitectura `EffectModule`.
