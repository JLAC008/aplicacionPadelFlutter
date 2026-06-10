import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/edit_match_result_dialog.dart';
import '../../data/mock_data.dart';

class RegularSeasonScreen extends StatefulWidget {
  const RegularSeasonScreen({super.key});

  @override
  State<RegularSeasonScreen> createState() => _RegularSeasonScreenState();
}

class _RegularSeasonScreenState extends State<RegularSeasonScreen> {
  final _mockTeams = [
    Team(id: 't1', players: [Player(id: 'p1', name: 'Juan', avatarUrl: '', padelBandScore: 8.5, padelBandRank: 1, level: 'Avanzado', liga: 'Peso Pesado', availability: [])], type: TeamType.duo, teamName: 'Los Titanes', wins: 3, losses: 0, position: 1, points: 9, mediaTecnica: 91.2, block: 2, jornadasGanadas: 3),
    Team(id: 't2', players: [Player(id: 'p2', name: 'Pedro', avatarUrl: '', padelBandScore: 8.2, padelBandRank: 2, level: 'Avanzado', liga: 'Peso Pesado', availability: [])], type: TeamType.duo, teamName: 'Los Fénix', wins: 2, losses: 1, position: 2, points: 7, mediaTecnica: 87.5, block: 2, jornadasGanadas: 2),
    Team(id: 't3', players: [Player(id: 'p3', name: 'Jaime', avatarUrl: '', padelBandScore: 8.0, padelBandRank: 3, level: 'Avanzado', liga: 'Peso Pesado', availability: [])], type: TeamType.duo, teamName: 'Los Guerreros', wins: 2, losses: 1, position: 3, points: 6, mediaTecnica: 85.0, block: 2, jornadasGanadas: 2),
    Team(id: 't4', players: [Player(id: 'p4', name: 'Marcos', avatarUrl: '', padelBandScore: 7.8, padelBandRank: 4, level: 'Avanzado', liga: 'Peso Pesado', availability: [])], type: TeamType.duo, teamName: 'Los Halcones', wins: 1, losses: 2, position: 4, points: 5, mediaTecnica: 82.3, block: 2, jornadasGanadas: 1),
    Team(id: 't5', players: [Player(id: 'p5', name: 'Pam', avatarUrl: '', padelBandScore: 7.6, padelBandRank: 5, level: 'Avanzado', liga: 'Peso Pesado', availability: [])], type: TeamType.duo, teamName: 'Las Reinas', wins: 1, losses: 2, position: 5, points: 4, mediaTecnica: 80.1, block: 2, jornadasGanadas: 1),
    Team(id: 't6', players: [Player(id: 'p6', name: 'Carlos', avatarUrl: '', padelBandScore: 7.4, padelBandRank: 6, level: 'Avanzado', liga: 'Peso Pesado', availability: [])], type: TeamType.duo, teamName: 'Las Viboras', wins: 1, losses: 2, position: 6, points: 3, mediaTecnica: 78.7, block: 1, jornadasGanadas: 1),
    Team(id: 't7', players: [Player(id: 'p7', name: 'Maria', avatarUrl: '', padelBandScore: 7.2, padelBandRank: 7, level: 'Avanzado', liga: 'Peso Pesado', availability: [])], type: TeamType.duo, teamName: 'Las Águilas', wins: 0, losses: 3, position: 7, points: 2, mediaTecnica: 75.4, block: 1, jornadasGanadas: 0),
    Team(id: 't8', players: [Player(id: 'p8', name: 'Carlos B', avatarUrl: '', padelBandScore: 7.0, padelBandRank: 8, level: 'Avanzado', liga: 'Peso Pesado', availability: [])], type: TeamType.duo, teamName: 'Los Novatos', wins: 0, losses: 3, position: 8, points: 1, mediaTecnica: 72.8, block: 1, jornadasGanadas: 0),
  ];

  late final List<Match> _mockMatches;
  late final List<Team> _priorityOrder;

  @override
  void initState() {
    super.initState();
    _mockMatches = [
      Match(id: 'm1', team1: _mockTeams[0], team2: _mockTeams[3], ligaId: 'l1', phase: TournamentPhase.regularSeason, jornada: 2, set1Team1: 6, set1Team2: 3, set2Team1: 6, set2Team2: 4, status: 'finished', winnerId: _mockTeams[0].id),
      Match(id: 'm2', team1: _mockTeams[1], team2: _mockTeams[4], ligaId: 'l1', phase: TournamentPhase.regularSeason, jornada: 2, set1Team1: 7, set1Team2: 5, set2Team1: 3, set2Team2: 6, set3Team1: 10, set3Team2: 8, status: 'finished', winnerId: _mockTeams[1].id),
      Match(id: 'm3', team1: _mockTeams[2], team2: _mockTeams[5], ligaId: 'l1', phase: TournamentPhase.regularSeason, jornada: 2, set1Team1: 6, set1Team2: 2, set2Team1: 7, set2Team2: 5, status: 'finished', winnerId: _mockTeams[2].id),
      Match(id: 'm4', team1: _mockTeams[6], team2: _mockTeams[7], ligaId: 'l1', phase: TournamentPhase.regularSeason, jornada: 2, status: 'scheduled'),
    ];
    _priorityOrder = [
      _mockTeams[0], _mockTeams[3], _mockTeams[1], _mockTeams[4],
      _mockTeams[2], _mockTeams[5], _mockTeams[6], _mockTeams[7],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = currentAppUser.isAdmin;
    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTitleBar(title: 'FASE 1: LIGA REGULAR', showBack: true),
              AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _JornadaBanner(),
                    const SizedBox(height: 20),
                    const SectionTitle('Orden de Prioridad'),
                    const SizedBox(height: 8),
                    _PriorityList(teams: _priorityOrder),
                    const SizedBox(height: 20),
                    const SectionTitle('Clasificación'),
                    const SizedBox(height: 8),
                    _StandingsTable(teams: _mockTeams),
                    const SizedBox(height: 20),
                    const SectionTitle('Partidos - Jornada 2'),
                    const SizedBox(height: 8),
                    ...List.generate(_mockMatches.length, (i) {
                      final match = _mockMatches[i];
                      return InkWell(
                        onTap: isAdmin ? () {
                          showEditMatchResultDialog(context, match, () => setState(() {}));
                        } : null,
                        borderRadius: BorderRadius.circular(14),
                        child: _MatchCard(match: match, isAdmin: isAdmin),
                      );
                    }),
                    const SizedBox(height: 20),
                    const SectionTitle('Información'),
                    const SizedBox(height: 8),
                    _RulesInfo(),
                    const SizedBox(height: 16),
                    Center(
                      child: GoldPillButton(
                        label: 'CREAR RETO',
                        icon: Icons.sports_tennis,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Función de reto próximamente'), backgroundColor: kTeal),
                          );
                        },
                      ),
                    ),
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

class _JornadaBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: elegantCard(active: true, radius: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_view_week, color: kGold, size: 24),
              const SizedBox(width: 10),
              const Text('Jornada 2/4',
                  style: TextStyle(color: kGold, fontSize: 24, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 2 / 4,
              backgroundColor: kCardBorder,
              valueColor: const AlwaysStoppedAnimation(kGold),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _JornadaDot(label: 'J1', active: true),
              _JornadaDot(label: 'J2', active: true),
              _JornadaDot(label: 'J3', active: false),
              _JornadaDot(label: 'J4', active: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _JornadaDot extends StatelessWidget {
  final String label;
  final bool active;
  const _JornadaDot({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: active ? kGold : kCard,
        borderRadius: BorderRadius.circular(12),
        border: active ? null : Border.all(color: kCardBorder),
      ),
      child: Text(label,
          style: TextStyle(
            color: active ? kOnGold : kTextSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          )),
    );
  }
}

class _PriorityList extends StatelessWidget {
  final List<Team> teams;
  const _PriorityList({required this.teams});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: elegantCard(radius: 14),
      child: Column(
        children: List.generate(teams.length, (i) {
          final team = teams[i];
          final isBlockA = team.block == 2;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text('${i + 1}.',
                    style: TextStyle(color: kGold, fontWeight: FontWeight.w900, fontSize: 13)),
                const SizedBox(width: 8),
                Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    color: isBlockA ? kTeal : kGold,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(team.displayName,
                    style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(isBlockA ? 'Block A' : 'Block B',
                    style: TextStyle(color: isBlockA ? kTeal : kGold, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StandingsTable extends StatelessWidget {
  final List<Team> teams;
  const _StandingsTable({required this.teams});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: elegantCard(radius: 14),
      child: Column(
        children: [
          Row(
            children: [
              _TH('Pos', flex: 1),
              _TH('Equipo', flex: 4),
              _TH('PJ', flex: 1),
              _TH('G', flex: 1),
              _TH('P', flex: 1),
              _TH('Pts', flex: 1),
            ],
          ),
          const Divider(color: kCardBorder),
          ...List.generate(teams.length, (i) {
            final t = teams[i];
            final isCurrent = t.displayName.contains('Juan');
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isCurrent ? kActiveCard : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _TD(Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: i < 4 ? kGold.withValues(alpha: 0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(child: Text('${t.position}', style: TextStyle(color: i < 4 ? kGold : kTextSecondary, fontWeight: FontWeight.w900, fontSize: 12))),
                  ), flex: 1),
                  _TD(Text(t.displayName, style: const TextStyle(color: kTextPrimary, fontSize: 12, fontWeight: FontWeight.w600)), flex: 4),
                  _TD(Text('${t.matchesPlayed}', style: const TextStyle(color: kTextSecondary, fontSize: 12)), flex: 1),
                  _TD(Text('${t.wins}', style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w700)), flex: 1),
                  _TD(Text('${t.losses}', style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w700)), flex: 1),
                  _TD(Text('${t.points}', style: const TextStyle(color: kGold, fontSize: 13, fontWeight: FontWeight.w900)), flex: 1),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

Widget _TH(String label, {int flex = 1}) {
  return Expanded(
    flex: flex,
    child: Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 10, fontWeight: FontWeight.w700)),
  );
}

Widget _TD(Widget child, {int flex = 1}) {
  return Expanded(flex: flex, child: child);
}

class _MatchCard extends StatelessWidget {
  final Match match;
  final bool isAdmin;
  const _MatchCard({required this.match, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final isFinished = match.isFinished;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: elegantCard(radius: 14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(match.team1.displayName,
                    style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 14))),
                const SizedBox(width: 8),
                if (isFinished)
                  Text('${match.team1Sets ?? 0}',
                      style: const TextStyle(color: kGold, fontWeight: FontWeight.w900, fontSize: 18))
                else
                  const Text('?', style: TextStyle(color: kTextSecondary, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text(match.team2.displayName,
                    style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 14))),
                const SizedBox(width: 8),
                if (isFinished)
                  Text('${match.team2Sets ?? 0}',
                      style: const TextStyle(color: kGold, fontWeight: FontWeight.w900, fontSize: 18))
                else
                  const Text('?', style: TextStyle(color: kTextSecondary, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                StatusChip(
                  label: isFinished ? 'Finalizado' : 'Programado',
                  color: isFinished ? kTeal : kGold,
                ),
                if (isAdmin) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, color: kTeal, size: 16),
                ],
                const Spacer(),
                if (match.isFinished)
                  Text('${match.set1Team1 ?? '-'}-${match.set1Team2 ?? '-'} / ${match.set2Team1 ?? '-'}-${match.set2Team2 ?? '-'}',
                      style: const TextStyle(color: kTextSecondary, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RulesInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: elegantCard(radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RuleRow(icon: Icons.swap_vert, title: 'Sistema de Prioridad', desc: 'El que más jornadas ganadas tiene escoge primero el horario de su partido.'),
          const Divider(color: kCardBorder, height: 16),
          _RuleRow(icon: Icons.trending_up, title: 'Escalada', desc: 'Block A (puestos 1-6) puede retar hacia arriba. Block B (7-12) busca escalar.'),
          const Divider(color: kCardBorder, height: 16),
          _RuleRow(icon: Icons.shield, title: 'Punto de Oro', desc: 'Se juega punto de oro en todos los juegos para aumentar la presión.'),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _RuleRow({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kTeal, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(color: kTextSecondary, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
