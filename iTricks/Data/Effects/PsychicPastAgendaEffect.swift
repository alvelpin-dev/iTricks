import SwiftUI

/// "La Agenda Psíquica del Pasado" — Mentalismo.
///
/// Método real (integrado en la app): en vez de tocar el Calendario real
/// del sistema (lo que requeriría permisos y dejaría rastro real),
/// iTricks renderiza su propia réplica de un mes de calendario con
/// matemática de fechas real (`Calendar`), navegando hasta el mes y año
/// exactos de la fecha de nacimiento introducida, con un evento forzado
/// ya colocado en el día correcto.
enum PsychicPastAgendaEffect: EffectModule {
    static let info = EffectInfo(
        id: "psychic_past_agenda",
        name: "La Agenda Psíquica del Pasado",
        category: .mentalism,
        shortDescription: "Dices tu fecha de nacimiento. El calendario del mago, en ese día exacto de hace años, ya tenía un mensaje para ti.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "calendar.badge.clock",
        instructions: EffectInstructions(
            whatItDoes: "Le pides a alguien que te diga su fecha de nacimiento. Abres el calendario de tu iPhone, viajas exactamente al día en que nació, y hay un evento creado ese mismo día que dice: \"Hoy nació la persona que verá este truco en el futuro\".",
            preparation: [
                "Configura el atajo descrito en los ajustes secretos, que crea el evento de calendario con fecha retroactiva en el momento de la actuación.",
                "Decide el texto exacto del evento (puedes personalizarlo en la configuración secreta)."
            ],
            performance: [
                "Pide a alguien que te diga su fecha de nacimiento completa.",
                "Introduce esa fecha en el atajo de forma disimulada, dejando que cree el evento en segundo plano.",
                "Abre la app Calendario real y navega hasta esa fecha exacta.",
                "Revela el evento ya creado en ese día, como si hubiera estado ahí desde siempre."
            ],
            script: [
                "\"Dime tu fecha de nacimiento completa, día, mes y año.\"",
                "\"Voy a ir a mi calendario, a ese día exacto, hace tantos años...\"",
                "\"Mira esto: ya había un evento creado ese mismo día.\""
            ],
            recoveryTips: [
                "Si el espectador no recuerda el año exacto, pídele que lo confirme con seguridad antes de introducirlo, ya que el evento debe coincidir con el día exacto que va a comprobar.",
                "Practica introducir la fecha rápidamente en el atajo para minimizar el tiempo de espera antes de abrir el calendario."
            ],
            performanceTips: [
                "Navega al calendario con calma, mostrando el recorrido por los meses y años para reforzar que realmente estás llegando a esa fecha concreta.",
                "No reveles el evento de inmediato: deja que el espectador busque la fecha contigo, aumentando la expectativa."
            ],
            variations: [
                "Personaliza el texto del evento con el nombre del espectador si lo conoces de antemano.",
                "Combínalo con un segundo evento en una fecha futura significativa, como cierre de la rutina."
            ],
            commonMistakes: [
                "Introducir mal la fecha en el atajo, lo que crea el evento en un día distinto al esperado.",
                "Mostrar el calendario con muchos otros eventos visibles alrededor, lo que puede distraer de la revelación."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide la fecha de nacimiento completa al espectador.",
                spectatorAction: "Comparte su fecha de nacimiento sin sospechar nada especial.",
                simulationNote: "La fecha se introduce en el atajo justo después de escucharla."
            ),
            PracticeStep(
                performerAction: "Crea el evento retroactivo en segundo plano y navega al calendario real hasta esa fecha.",
                spectatorAction: "Ve al mago navegar el calendario hasta el día exacto de su nacimiento.",
                simulationNote: "El evento se crea en el momento real, pero con la fecha pasada indicada por el espectador."
            ),
            PracticeStep(
                performerAction: "Revela el evento ya presente en ese día.",
                spectatorAction: "Descubre el mensaje preescrito en el día exacto de su nacimiento.",
                simulationNote: "El sistema de calendario permite crear eventos en cualquier fecha pasada sin restricción."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(PsychicPastAgendaPerformView()) }
    static func settingsView() -> AnyView { AnyView(PsychicPastAgendaSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct PsychicPastAgendaPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("psychic_agenda_event_text") private var eventText = "Hoy nació la persona que verá este truco en el futuro"
    @State private var birthDate = Date()
    @State private var revealed = false

    private var calendar: Calendar { Calendar.current }

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.md) {
                if revealed {
                    monthGrid
                } else {
                    Spacer()
                    Text("Fecha de nacimiento")
                        .font(Theme.Typography.headline)
                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    PrimaryButton("Viajar a esa fecha", symbol: "calendar", tint: .brown) {
                        withAnimation(Theme.AnimationCurve.standard) { revealed = true }
                        MagicEngine.performReveal()
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    Spacer()
                }
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private var monthGrid: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Text(birthDate, format: .dateTime.month(.wide).year())
                .font(Theme.Typography.title)
                .padding(.top, Theme.Spacing.md)

            let days = daysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                    if let day {
                        VStack(spacing: 2) {
                            Text("\(day)")
                                .font(.system(size: 14, weight: isBirthDay(day) ? .bold : .regular))
                                .foregroundStyle(isBirthDay(day) ? .white : .primary)
                                .frame(width: 30, height: 30)
                                .background(isBirthDay(day) ? Color.brown : Color.clear, in: Circle())
                            if isBirthDay(day) {
                                Circle().fill(Color.brown).frame(width: 5, height: 5)
                            }
                        }
                    } else {
                        Color.clear.frame(width: 30, height: 30)
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.md)

            if let day = calendar.dateComponents([.day], from: birthDate).day {
                GlassCard {
                    Text(eventText)
                        .font(Theme.Typography.body)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.top, Theme.Spacing.sm)
                .id(day)
            }

            Spacer()
        }
    }

    private func daysInMonth() -> [Int?] {
        guard let range = calendar.range(of: .day, in: .month, for: birthDate) else { return [] }
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: birthDate)) ?? birthDate
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let leadingBlanks = (weekday - calendar.firstWeekday + 7) % 7
        return Array(repeating: nil, count: leadingBlanks) + range.map { $0 }
    }

    private func isBirthDay(_ day: Int) -> Bool {
        calendar.component(.day, from: birthDate) == day
    }
}

private struct PsychicPastAgendaSettingsView: View {
    @AppStorage("psychic_agenda_event_text") private var eventText = "Hoy nació la persona que verá este truco en el futuro"

    var body: some View {
        SecretConfigScreen(title: "La Agenda Psíquica del Pasado") {
            Section("Texto del evento forzado") {
                TextField("Texto del evento", text: $eventText, axis: .vertical)
            }
            Section {
                Text("La app calcula matemáticamente el mes exacto y el día de la semana real de la fecha de nacimiento introducida, mostrando una réplica de calendario con el evento forzado ya colocado en el día correcto.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
