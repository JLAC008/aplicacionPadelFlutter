import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';

class ChampionshipScreen extends StatefulWidget {
  const ChampionshipScreen({super.key});

  @override
  State<ChampionshipScreen> createState() => _ChampionshipScreenState();
}

class _ChampionshipScreenState extends State<ChampionshipScreen> {
  final _mockTeams = List.generate(8, (i) {
    final name = _names[i];
    return Team(
      id: 'ct${i + 1}',
      players: [Player(id: 'cp${i + 1}', name: name, avatarUrl: '', padelBandScore: 9.0 - i * 0.3, padelBandRank: i + 1, level: 'Avanzado', liga: 'Peso Pesado', availability: [])],
      type: TeamType.duo,
      teamName: _campTeamNames[i],
      position: i + 1,
      mediaTecnica: 92 - i * 4.0,
    );
  });

  static const _names = ['Juan', 'Pedro', 'Jaime', 'Marcos', 'Pam', 'Carlos', 'Maria', 'Carlos B'];
  static const _campTeamNames = ['Los Titanes', 'Los Fénix', 'Los Guerreros', 'Los Halcones', 'Las Reinas', 'Las Viboras', 'Las Águilas', 'Los Lobos'];

  late List<(Team, Team, String, Team)> _quarterFinals;
  late List<(Team, Team, String, Team, int)> _semiFinals;
  late (Team, Team, String, Team) _grandFinal;

  @override
  void initState() {
    super.initState();
    _quarterFinals = [
      (_mockTeams[0], _mockTeams[7], '6-2 / 6-4', _mockTeams[0]),
      (_mockTeams[1], _mockTeams[6], '7-5 / 6-3', _mockTeams[1]),
      (_mockTeams[2], _mockTeams[5], '6-4 / 3-6 / 10-7', _mockTeams[2]),
      (_mockTeams[3], _mockTeams[4], '6-3 / 7-6', _mockTeams[3]),
    ];
    _semiFinals = [
      (_mockTeams[0], _mockTeams[3], '6-7 / 6-4 / 10-8', _mockTeams[0], 2),
      (_mockTeams[1], _mockTeams[2], '6-3 / 3-6 / 10-5', _mockTeams[1], 2),
    ];
    _grandFinal = (
      _mockTeams[0],
      _mockTeams[1],
      '6-4 / 4-6 / 10-7',
      _mockTeams[0],
    );
  }

  void _editScoreString(void Function(String) onSave, String current) {
    final ctrl = TextEditingController(text: current);
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
              final s = ctrl.text.trim();
              if (s.isNotEmpty) { onSave(s); setState(() {}); }
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

    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTitleBar(title: 'FASE 3: CHAMPIONSHIP', showBack: true),
              AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChampionshipHeader(),
                    const SizedBox(height: 20),
                    const SectionTitle('CUARTOS DE FINAL'),
                    const SizedBox(height: 8),
                    ...List.generate(_quarterFinals.length, (i) {
                      final (t1, t2, score, winner) = _quarterFinals[i];
                      return InkWell(
                        onTap: isAdmin ? () => _editScoreString((s) { _quarterFinals[i] = (t1, t2, s, winner); }, score) : null,
                        borderRadius: BorderRadius.circular(14),
                        child: _BracketMatchCard(label: 'QF${i + 1}', team1: t1, team2: t2, score: score, winner: winner, isAdmin: isAdmin),
                      );
                    }),
                    const SizedBox(height: 20),
                    const SectionTitle('SEMI FINALES (Best of 3 Sets)'),
                    const SizedBox(height: 8),
                    ...List.generate(_semiFinals.length, (i) {
                      final (t1, t2, score, winner, _) = _semiFinals[i];
                      return InkWell(
                        onTap: isAdmin ? () => _editScoreString((s) { _semiFinals[i] = (t1, t2, s, winner, 2); }, score) : null,
                        borderRadius: BorderRadius.circular(14),
                        child: _BracketMatchCard(label: 'SF${i + 1}', team1: t1, team2: t2, score: score, winner: winner, isSemi: true, isAdmin: isAdmin),
                      );
                    }),
                    const SizedBox(height: 20),
                    const SectionTitle('GRAN FINAL'),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: isAdmin ? () => _editScoreString((s) { _grandFinal = (_grandFinal.$1, _grandFinal.$2, s, _grandFinal.$4); }, _grandFinal.$3) : null,
                      borderRadius: BorderRadius.circular(18),
                      child: _GrandFinalCard(team1: _grandFinal.$1, team2: _grandFinal.$2, score: _grandFinal.$3, winner: _grandFinal.$4, isAdmin: isAdmin),
                    ),
                    const SizedBox(height: 20),
                    _BeltCeremony(winner: _grandFinal.$4),
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

class _ChampionshipHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: elegantCard(active: true, radius: 16),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: kGold, size: 44),
          const SizedBox(height: 10),
          const Text('CHAMPIONSHIP',
              style: TextStyle(color: kGold, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Cuartos · Semifinales · Gran Final · Ceremonia del Cinturón',
              style: TextStyle(color: kTextSecondary, fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _BracketMatchCard extends StatelessWidget {
  final String label;
  final Team team1;
  final Team team2;
  final String score;
  final Team winner;
  final bool isSemi;
  final bool isAdmin;

  const _BracketMatchCard({
    required this.label,
    required this.team1,
    required this.team2,
    required this.score,
    required this.winner,
    this.isSemi = false,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: elegantCard(radius: 14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSemi ? kTeal.withValues(alpha: 0.15) : kGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(label,
                      style: TextStyle(color: isSemi ? kTeal : kGold, fontWeight: FontWeight.w900, fontSize: 11)),
                ),
                if (isSemi) ...[
                  const SizedBox(width: 8),
                  const Text('Best of 3 Sets', style: TextStyle(color: kTextSecondary, fontSize: 10)),
                ],
                if (isAdmin) ...[
                  const Spacer(),
                  const Icon(Icons.edit, color: kTeal, size: 16),
                ],
              ],
            ),
            const SizedBox(height: 10),
            _BracketTeamRow(team: team1, isWinner: winner.id == team1.id),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: kCardBorder)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: kTeal.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(score, style: const TextStyle(color: kTeal, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                  const Expanded(child: Divider(color: kCardBorder)),
                ],
              ),
            ),
            _BracketTeamRow(team: team2, isWinner: winner.id == team2.id),
          ],
        ),
      ),
    );
  }
}

class _BracketTeamRow extends StatelessWidget {
  final Team team;
  final bool isWinner;
  const _BracketTeamRow({required this.team, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (isWinner) const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
              if (isWinner) const SizedBox(width: 6),
              Expanded(
                child: Text(team.displayName,
                    style: TextStyle(
                      color: isWinner ? kTextPrimary : kTextSecondary,
                      fontWeight: isWinner ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 14,
                    )),
              ),
            ],
          ),
        ),
        Text('MT: ${team.mediaTecnica.toStringAsFixed(1)}',
            style: TextStyle(color: isWinner ? kGold : kTextSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _GrandFinalCard extends StatelessWidget {
  final Team team1;
  final Team team2;
  final String score;
  final Team winner;
  final bool isAdmin;

  const _GrandFinalCard({
    required this.team1,
    required this.team2,
    required this.score,
    required this.winner,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kGold.withValues(alpha: 0.12), kActiveCard],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kGold.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [BoxShadow(color: kGold.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 2)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: kGold, size: 32),
              const SizedBox(width: 8),
              const Text('GRAN FINAL', style: TextStyle(color: kGold, fontSize: 20, fontWeight: FontWeight.w900)),
              if (isAdmin) ...[
                const Spacer(),
                const Icon(Icons.edit, color: kTeal, size: 18),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _FinalTeamRow(team: team1, isWinner: winner.id == team1.id),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('VS', style: TextStyle(color: kGold, fontSize: 22, fontWeight: FontWeight.w900)),
          ),
          _FinalTeamRow(team: team2, isWinner: winner.id == team2.id),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: winner.id == team1.id ? Colors.greenAccent.withValues(alpha: 0.1) : Colors.blueAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(winner.id == team1.id ? Icons.check_circle : Icons.emoji_events, color: kGold, size: 20),
                const SizedBox(width: 8),
                Text('Campeón: ${winner.displayName}',
                    style: const TextStyle(color: kGold, fontWeight: FontWeight.w900, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalTeamRow extends StatelessWidget {
  final Team team;
  final bool isWinner;
  const _FinalTeamRow({required this.team, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isWinner ? kGold.withValues(alpha: 0.08) : kBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isWinner ? kGold.withValues(alpha: 0.4) : kCardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: kCardBorder,
            child: Text(team.displayName[0],
                style: const TextStyle(color: kGold, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(team.displayName,
                    style: TextStyle(color: isWinner ? kTextPrimary : kTextSecondary, fontWeight: FontWeight.w800, fontSize: 16)),
                Text('Media Técnica: ${team.mediaTecnica.toStringAsFixed(1)}',
                    style: const TextStyle(color: kTextSecondary, fontSize: 11)),
              ],
            ),
          ),
          if (isWinner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(8)),
              child: const Text('CAMPEÓN',
                  style: TextStyle(color: kOnGold, fontSize: 10, fontWeight: FontWeight.w900)),
            ),
        ],
      ),
    );
  }
}

class _BeltCeremony extends StatelessWidget {
  final Team winner;
  const _BeltCeremony({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: elegantCard(radius: 16),
      child: Column(
        children: [
          const Icon(Icons.workspace_premium, color: kGold, size: 48),
          const SizedBox(height: 10),
          const Text('CEREMONIA DEL CINTURÓN',
              style: TextStyle(color: kGold, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('${winner.displayName} recibe el cinturón de campeones',
              style: const TextStyle(color: kTextSecondary, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CeremonyDetail(icon: Icons.music_note, label: 'Walk-out Music'),
              const SizedBox(width: 20),
              _CeremonyDetail(icon: Icons.mic, label: 'Post-fight Interview'),
              const SizedBox(width: 20),
              _CeremonyDetail(icon: Icons.photo_camera, label: 'Photo Session'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CeremonyDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CeremonyDetail({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: kTeal, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 9), textAlign: TextAlign.center),
      ],
    );
  }
}
