import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';

class RepechageScreen extends StatefulWidget {
  const RepechageScreen({super.key});

  @override
  State<RepechageScreen> createState() => _RepechageScreenState();
}

class _RepechageScreenState extends State<RepechageScreen> {
  final _mockTeams = List.generate(12, (i) {
    final name = _names[i];
    return Team(
      id: 't${i + 1}',
      players: [Player(id: 'p${i + 1}', name: name, avatarUrl: '', padelBandScore: 8.5 - i * 0.2, padelBandRank: i + 1, level: 'Avanzado', liga: 'Peso Pesado', availability: [])],
      type: TeamType.duo,
      teamName: _teamNames[i],
      position: i + 1,
      points: 12 - i,
      wins: 4 - (i > 3 ? (i - 3) : 0),
      losses: (i > 3 ? i - 3 : 0) + 1,
      mediaTecnica: 90 - i * 3.5,
      block: i < 6 ? 2 : 1,
    );
  });

  static const _names = ['Juan', 'Pedro', 'Jaime', 'Marcos', 'Pam', 'Carlos', 'Maria', 'Carlos B', 'Maria L', 'Bere', 'Mati', 'Beamos'];
  static const _teamNames = ['Los Titanes', 'Los Fénix', 'Los Guerreros', 'Los Halcones', 'Las Reinas', 'Las Viboras', 'Las Águilas', 'Los Lobos', 'Las Panteras', 'Los Toros', 'Los Leones', 'Los Novatos'];
  static const _matchupLabels = ['5º vs 12º', '6º vs 11º', '7º vs 10º', '8º vs 9º'];

  late final List<(Team, Team, String, Team)> _crossMatchups;

  @override
  void initState() {
    super.initState();
    _crossMatchups = [
      (_mockTeams[4], _mockTeams[11], '6-3 / 7-5', _mockTeams[4]),
      (_mockTeams[5], _mockTeams[10], '6-4 / 3-6 / 10-7', _mockTeams[5]),
      (_mockTeams[6], _mockTeams[9], '7-6 / 6-2', _mockTeams[6]),
      (_mockTeams[7], _mockTeams[8], '4-6 / 6-3 / 10-5', _mockTeams[7]),
    ];
  }

  void _editScore(int index, String currentScore) {
    final ctrl = TextEditingController(text: currentScore);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Editar Marcador', style: TextStyle(color: kGold, fontWeight: FontWeight.w900)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: kTextPrimary),
          decoration: const InputDecoration(
            labelText: 'Marcador (ej: 6-3 / 7-5)',
            labelStyle: TextStyle(color: kTextSecondary),
            filled: true,
            fillColor: kBg,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: kTextSecondary))),
          ElevatedButton(
            onPressed: () {
              final newScore = ctrl.text.trim();
              if (newScore.isNotEmpty) {
                final old = _crossMatchups[index];
                _crossMatchups[index] = (old.$1, old.$2, newScore, old.$4);
                setState(() {});
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: kTeal),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = currentAppUser.isAdmin;
    final directQualifiers = _mockTeams.take(4).toList();

    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTitleBar(title: 'FASE 2: LA REPESCA', showBack: true),
              AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RepechageHeader(),
                    const SizedBox(height: 20),
                    const SectionTitle('Clasificados Directos (1º-4º)'),
                    const SizedBox(height: 8),
                    ...List.generate(directQualifiers.length, (i) => _DirectQualifierRow(team: directQualifiers[i], position: i + 1)),
                    const SizedBox(height: 20),
                    const SectionTitle('Cruces de Repesca'),
                    const SizedBox(height: 8),
                    ...List.generate(_crossMatchups.length, (i) {
                      final (t1, t2, score, winner) = _crossMatchups[i];
                      return InkWell(
                        onTap: isAdmin ? () => _editScore(i, score) : null,
                        borderRadius: BorderRadius.circular(14),
                        child: _RepechageMatchCard(
                          matchupLabel: _matchupLabels[i],
                          team1: t1,
                          team2: t2,
                          score: score,
                          winner: winner,
                          isAdmin: isAdmin,
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    const SectionTitle('Avanzan a Cuartos'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: elegantCard(active: true, radius: 14),
                      child: Column(
                        children: [
                          const Text('Clasificados para Cuartos de Final',
                              style: TextStyle(color: kGold, fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (i) {
                              final c = _crossMatchups[i];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Chip(
                                  label: Text(c.$4.displayName.split(' ').first,
                                      style: const TextStyle(color: kOnGold, fontSize: 11, fontWeight: FontWeight.w700)),
                                  backgroundColor: kGold,
                                  side: BorderSide.none,
                                ),
                              );
                            }),
                          ),
                        ],
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

class _RepechageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: elegantCard(active: true, radius: 16),
      child: Column(
        children: [
          const Icon(Icons.swap_horiz, color: kGold, size: 40),
          const SizedBox(height: 10),
          const Text('WILDCARD ROUND',
              style: TextStyle(color: kGold, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Los equipos del 5º al 12º se enfrentan en cruces eliminación directa. Los 4 ganadores avanzan a cuartos de final.',
              style: TextStyle(color: kTextSecondary, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _DirectQualifierRow extends StatelessWidget {
  final Team team;
  final int position;
  const _DirectQualifierRow({required this.team, required this.position});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: elegantCard(radius: 14),
        child: Row(
          children: [
            GoldBadge(number: position, size: 26),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 16,
              backgroundColor: kCardBorder,
              child: Text(team.displayName[0],
                  style: const TextStyle(color: kGold, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(team.displayName,
                      style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
                  Text('${team.points} pts · ${team.wins}G/${team.losses}P',
                      style: const TextStyle(color: kTextSecondary, fontSize: 11)),
                ],
              ),
            ),
            const StatusChip(label: 'CLASIF', color: kTeal),
          ],
        ),
      ),
    );
  }
}

class _RepechageMatchCard extends StatelessWidget {
  final String matchupLabel;
  final Team team1;
  final Team team2;
  final String score;
  final Team winner;
  final bool isAdmin;

  const _RepechageMatchCard({
    required this.matchupLabel,
    required this.team1,
    required this.team2,
    required this.score,
    required this.winner,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: elegantCard(radius: 14, active: true, color: kActiveCard),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: kGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(matchupLabel,
                      style: const TextStyle(color: kGold, fontSize: 12, fontWeight: FontWeight.w800)),
                ),
                if (isAdmin) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, color: kTeal, size: 16),
                ],
              ],
            ),
            const SizedBox(height: 12),
            _MatchupTeam(team: team1, isWinner: winner.id == team1.id),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: kCardBorder)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: kTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(score,
                        style: const TextStyle(color: kTeal, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  const Expanded(child: Divider(color: kCardBorder)),
                ],
              ),
            ),
            _MatchupTeam(team: team2, isWinner: winner.id == team2.id),
          ],
        ),
      ),
    );
  }
}

class _MatchupTeam extends StatelessWidget {
  final Team team;
  final bool isWinner;
  const _MatchupTeam({required this.team, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isWinner)
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
        if (isWinner) const SizedBox(width: 6),
        Expanded(
          child: Text(team.displayName,
              style: TextStyle(
                color: isWinner ? kTextPrimary : kTextSecondary,
                fontWeight: isWinner ? FontWeight.w800 : FontWeight.w500,
                fontSize: 14,
              )),
        ),
        if (isWinner)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('GANA',
                style: TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.w900)),
          ),
      ],
    );
  }
}
