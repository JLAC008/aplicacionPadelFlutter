import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import 'draft_screen.dart';
import 'regular_season_screen.dart';
import 'repechage_screen.dart';
import 'championship_screen.dart';

class TorneoScreen extends StatelessWidget {
  const TorneoScreen({super.key});

  static final _mockSeason = Season(
    id: 's1',
    name: 'Temporada 1 - 2026',
    startDate: DateTime(2026, 1, 15),
    endDate: DateTime(2026, 6, 30),
    ligas: [],
    allMatches: [],
    jornadaDeadlines: {
      1: DateTime(2026, 1, 22),
      2: DateTime(2026, 2, 5),
      3: DateTime(2026, 2, 19),
      4: DateTime(2026, 3, 5),
    },
  );

  static final _mockEvents = [
    CalendarEvent(date: DateTime(2026, 6, 8), title: 'Lanzar el Guante', description: 'Inicio de jornada 4', type: 'challengeDay'),
    CalendarEvent(date: DateTime(2026, 6, 9), title: 'Jornada 4', description: 'Ventana de juego: Mar-Dom', type: 'playDay'),
    CalendarEvent(date: DateTime(2026, 6, 15), title: 'Cierre Jornada 4', description: 'Resultados deben estar verificados', type: 'deadline'),
    CalendarEvent(date: DateTime(2026, 6, 22), title: 'Inicio Repesca', description: 'Wildcard Round', type: 'event'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              const AppTitleBar(title: 'Torneo'),
              AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SeasonBanner(season: _mockSeason),
                    const SizedBox(height: 18),
                    _PhaseTimeline(currentPhase: TournamentPhase.regularSeason),
                    const SizedBox(height: 20),
                    _PhaseActionCard(currentPhase: TournamentPhase.regularSeason),
                    const SizedBox(height: 24),
                    SectionTitle('Calendario'),
                    const SizedBox(height: 8),
                    ...List.generate(_mockEvents.length, (i) => _EventCard(event: _mockEvents[i])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeasonBanner extends StatelessWidget {
  final Season season;
  const _SeasonBanner({required this.season});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: elegantCard(active: true, radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: kGold, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(season.name,
                    style: const TextStyle(color: kGold, fontSize: 20, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(icon: Icons.calendar_today, label: '${season.startDate.day}/${season.startDate.month} - ${season.endDate.day}/${season.endDate.month}'),
              const SizedBox(width: 12),
              _InfoChip(icon: Icons.sports_tennis, label: 'Fase 1: Regular'),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Próximo evento: Lanzar el Guante (Lunes)',
              style: TextStyle(color: kTextSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kTeal, size: 14),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PhaseTimeline extends StatelessWidget {
  final TournamentPhase currentPhase;
  const _PhaseTimeline({required this.currentPhase});

  static const _phases = [
    (TournamentPhase.draft, 'Draft'),
    (TournamentPhase.regularSeason, 'Regular'),
    (TournamentPhase.repechage, 'Repesca'),
    (TournamentPhase.quarterFinal, 'Championship'),
  ];

  int get _currentIndex {
    for (int i = 0; i < _phases.length; i++) {
      if (_phases[i].$1 == currentPhase) return i;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Progreso del Torneo',
            style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        Row(
          children: List.generate(_phases.length, (i) {
            final done = i < _currentIndex;
            final active = i == _currentIndex;
            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      if (i > 0)
                        Expanded(
                          child: Container(
                            height: 3,
                            color: done || active ? kGold : kCardBorder,
                          ),
                        ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done ? kGold : (active ? kActiveCard : kCard),
                          border: Border.all(
                            color: active ? kGold : kCardBorder,
                            width: active ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: done
                              ? const Icon(Icons.check, color: kOnGold, size: 18)
                              : Text('${i + 1}',
                                  style: TextStyle(
                                    color: active ? kGold : kTextSecondary,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(_phases[i].$2,
                      style: TextStyle(
                        color: active ? kGold : kTextSecondary,
                        fontSize: 10,
                        fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                      )),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _PhaseActionCard extends StatelessWidget {
  final TournamentPhase currentPhase;
  const _PhaseActionCard({required this.currentPhase});

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    IconData icon;
    String buttonLabel;
    Widget target;

    switch (currentPhase) {
      case TournamentPhase.draft:
        title = 'FASE 0: EL DRAFT';
        subtitle = 'Simulaciones y ranking inicial';
        icon = Icons.auto_graph;
        buttonLabel = 'VER DRAFT';
        target = const DraftScreen();
      case TournamentPhase.regularSeason:
        title = 'FASE 1: LIGA REGULAR';
        subtitle = 'Jornada 2/4 · Prioridad activa';
        icon = Icons.emoji_events;
        buttonLabel = 'VER JORNADA';
        target = const RegularSeasonScreen();
      case TournamentPhase.repechage:
        title = 'FASE 2: LA REPESCA';
        subtitle = 'Wildcard Round - cruces 5v12, 6v11...';
        icon = Icons.swap_horiz;
        buttonLabel = 'VER REPESCA';
        target = const RepechageScreen();
      default:
        title = 'FASE 3: CHAMPIONSHIP';
        subtitle = 'Cuartos · Semis · Gran Final';
        icon = Icons.emoji_events;
        buttonLabel = 'VER CHAMPIONSHIP';
        target = const ChampionshipScreen();
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: elegantCard(radius: 18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: kGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: kGold, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: kGold, fontSize: 15, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                ],
              ),
            ),
            GoldPillButton(label: buttonLabel, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target))),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final CalendarEvent event;
  const _EventCard({required this.event});

  IconData get _icon {
    switch (event.type) {
      case 'challengeDay': return Icons.sports_tennis;
      case 'playDay': return Icons.play_circle_outline;
      case 'deadline': return Icons.access_time;
      default: return Icons.event;
    }
  }

  Color get _color {
    switch (event.type) {
      case 'challengeDay': return kTeal;
      case 'playDay': return kGold;
      case 'deadline': return Colors.orangeAccent;
      default: return kTeal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = event.date.day.toString().padLeft(2, '0');
    final month = event.date.month.toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: elegantCard(radius: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text('$day/$month',
                    style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(event.description,
                      style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                ],
              ),
            ),
            Icon(_icon, color: _color, size: 22),
          ],
        ),
      ),
    );
  }
}
