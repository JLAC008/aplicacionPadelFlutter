import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import 'draft_screen.dart';
import 'regular_season_screen.dart';
import 'repechage_screen.dart';
import 'championship_screen.dart';

class TorneoScreen extends StatefulWidget {
  const TorneoScreen({super.key});

  @override
  State<TorneoScreen> createState() => _TorneoScreenState();
}

class _TorneoScreenState extends State<TorneoScreen> {
  static final _mockEvents = [
    CalendarEvent(date: DateTime(2026, 6, 8), title: 'Lanzar el Guante', description: 'Inicio de jornada 4', type: 'challengeDay'),
    CalendarEvent(date: DateTime(2026, 6, 9), title: 'Jornada 4', description: 'Ventana de juego: Mar-Dom', type: 'playDay'),
    CalendarEvent(date: DateTime(2026, 6, 15), title: 'Cierre Jornada 4', description: 'Resultados deben estar verificados', type: 'deadline'),
    CalendarEvent(date: DateTime(2026, 6, 22), title: 'Inicio Repesca', description: 'Wildcard Round', type: 'event'),
  ];

  void _openRegistration() {
    final partnerCtrl = TextEditingController();
    final teamNameCtrl = TextEditingController(text: '${currentUser.name} & ');
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: kCardBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            const Text('Inscripción al Torneo',
                style: TextStyle(color: kGold, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kActiveCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kCardBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: kCardBorder,
                    child: Text(currentUser.name[0],
                        style: const TextStyle(color: kGold, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentUser.name,
                          style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w800)),
                      Text('Tú', style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: partnerCtrl,
              style: const TextStyle(color: kTextPrimary),
              decoration: InputDecoration(
                labelText: 'Compañero (opcional)',
                hintText: 'Nombre de tu compañero',
                hintStyle: const TextStyle(color: kTextSecondary),
                labelStyle: const TextStyle(color: kTextSecondary),
                filled: true,
                fillColor: kBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: teamNameCtrl,
              style: const TextStyle(color: kTextPrimary),
              decoration: InputDecoration(
                labelText: 'Nombre del equipo',
                labelStyle: const TextStyle(color: kTextSecondary),
                filled: true,
                fillColor: kBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final teamName = teamNameCtrl.text.trim();
                  if (teamName.isEmpty) return;
                  mockRegistrations.add(TournamentRegistration(
                    id: 'reg_${DateTime.now().millisecondsSinceEpoch}',
                    seasonId: mockCurrentSeason.id,
                    teamName: teamName,
                    player1: currentUser,
                    registeredAt: DateTime.now(),
                    notes: partnerCtrl.text.trim().isNotEmpty ? 'Compañero: ${partnerCtrl.text.trim()}' : null,
                  ));
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inscripción enviada. Pendiente de aprobación.'),
                      backgroundColor: kTeal,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTeal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Inscribirme', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RegistrationStatus? _myStatus() {
    final regs = mockRegistrations.where((r) =>
        r.seasonId == mockCurrentSeason.id &&
        r.players.any((p) => p.id == currentUser.id));
    if (regs.isEmpty) return null;
    return regs.first.status;
  }

  @override
  Widget build(BuildContext context) {
    final myStatus = _myStatus();
    final acceptedRegs = mockRegistrations.where((r) =>
        r.seasonId == mockCurrentSeason.id &&
        r.status == RegistrationStatus.accepted).toList();

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
                    _SeasonBanner(season: mockCurrentSeason),
                    const SizedBox(height: 14),
                    _RegistrationCard(
                      status: myStatus,
                      teamCount: acceptedRegs.length,
                      onRegister: _openRegistration,
                    ),
                    const SizedBox(height: 18),
                    _PhaseTimeline(currentPhase: TournamentPhase.regularSeason),
                    const SizedBox(height: 20),
                    _PhaseActionCard(currentPhase: TournamentPhase.regularSeason),
                    if (acceptedRegs.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      SectionTitle('Equipos inscritos (${acceptedRegs.length})'),
                      const SizedBox(height: 8),
                      ...List.generate(acceptedRegs.length, (i) {
                        final reg = acceptedRegs[i];
                        return _RegisteredTeamCard(registration: reg);
                      }),
                    ],
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

class _RegisteredTeamCard extends StatelessWidget {
  final TournamentRegistration registration;
  const _RegisteredTeamCard({required this.registration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: elegantCard(radius: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: kCardBorder,
              child: Text(registration.teamName[0],
                  style: const TextStyle(color: kGold, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(registration.teamName,
                      style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(registration.players.map((p) => p.name).join(' · '),
                      style: const TextStyle(color: kTextSecondary, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.check_circle, color: kTeal, size: 18),
          ],
        ),
      ),
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  final RegistrationStatus? status;
  final int teamCount;
  final VoidCallback onRegister;
  const _RegistrationCard({
    required this.status,
    required this.teamCount,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: elegantCard(radius: 16, active: status == null),
      child: Column(
        children: [
          if (status == null) ...[
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: kTeal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_add, color: kTeal, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Inscríbete al torneo',
                          style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w800, fontSize: 15)),
                      Text('$teamCount equipos apuntados',
                          style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTeal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Inscribirme', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: status == RegistrationStatus.accepted
                        ? Colors.greenAccent.withValues(alpha: 0.12)
                        : Colors.orangeAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    status == RegistrationStatus.accepted ? Icons.check_circle : Icons.hourglass_empty,
                    color: status == RegistrationStatus.accepted ? Colors.greenAccent : Colors.orangeAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status == RegistrationStatus.accepted ? 'Inscrito' : 'Inscripción pendiente',
                        style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      Text(
                        status == RegistrationStatus.accepted
                            ? 'Formas parte del torneo'
                            : 'Esperando aprobación del admin',
                        style: const TextStyle(color: kTextSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                StatusChip(
                  label: status == RegistrationStatus.accepted ? 'ACEPTADO' : 'PENDIENTE',
                  color: status == RegistrationStatus.accepted ? kTeal : Colors.orangeAccent,
                ),
              ],
            ),
          ],
        ],
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
