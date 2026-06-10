import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class DraftScreen extends StatelessWidget {
  const DraftScreen({super.key});

  static final _mockDraftResults = [
    DraftResult(player: Player(id: 'p1', name: 'Juan', avatarUrl: '', padelBandScore: 8.5, padelBandRank: 1, level: 'Avanzado', liga: 'Peso Pesado', availability: []), strikeRate: 92.5, position: 1),
    DraftResult(player: Player(id: 'p2', name: 'Pedro', avatarUrl: '', padelBandScore: 8.2, padelBandRank: 2, level: 'Avanzado', liga: 'Peso Pesado', availability: []), strikeRate: 88.3, position: 2),
    DraftResult(player: Player(id: 'p3', name: 'Jaime', avatarUrl: '', padelBandScore: 8.0, padelBandRank: 3, level: 'Avanzado', liga: 'Peso Pesado', availability: []), strikeRate: 85.1, position: 3),
    DraftResult(player: Player(id: 'p4', name: 'Marcos', avatarUrl: '', padelBandScore: 7.8, padelBandRank: 4, level: 'Avanzado', liga: 'Peso Pesado', availability: []), strikeRate: 82.7, position: 4),
    DraftResult(player: Player(id: 'p5', name: 'Pam', avatarUrl: '', padelBandScore: 7.6, padelBandRank: 5, level: 'Avanzado', liga: 'Peso Pesado', availability: []), strikeRate: 80.0, position: 5),
    DraftResult(player: Player(id: 'p10', name: 'Bere', avatarUrl: '', padelBandScore: 6.5, padelBandRank: 10, level: 'Avanzado', liga: 'Peso Pesado', availability: []), strikeRate: 71.2, position: 6),
    DraftResult(player: Player(id: 'p11', name: 'Mati', avatarUrl: '', padelBandScore: 6.3, padelBandRank: 11, level: 'Avanzado', liga: 'Peso Pesado', availability: []), strikeRate: 68.9, position: 7),
  ];

  static final _mockTrialMatches = [
    'Juan & Pedro vs Bere & Mati → 6-3',
    'Jaime & Marcos vs Pam & Ligma → 7-5',
    'Carlos & Maria vs Daopo & Lommelan → 6-2',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTitleBar(title: 'FASE 0: EL DRAFT', showBack: true),
              AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DraftHeader(),
                    const SizedBox(height: 20),
                    const SectionTitle('Ranking del Draft'),
                    const SizedBox(height: 8),
                    PadelFadeInList(
                      itemCount: _mockDraftResults.length,
                      itemBuilder: (i) {
                        final result = _mockDraftResults[i];
                        final isCurrentUser = result.player.name == 'Juan';
                        return _DraftPlayerRow(result: result, isCurrentUser: isCurrentUser);
                      },
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle('Partidos de Prueba'),
                    const SizedBox(height: 8),
                    ...List.generate(_mockTrialMatches.length, (i) => _TrialMatchCard(index: i + 1, result: _mockTrialMatches[i])),
                    const SizedBox(height: 24),
                    Center(
                      child: GoldPillButton(
                        label: 'CALCULAR RANKING INICIAL',
                        icon: Icons.auto_graph,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ranking calculado correctamente'), backgroundColor: kTeal),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text('Simulación completada. Los resultados del draft determinan las posiciones iniciales.',
                          style: TextStyle(color: kTextSecondary, fontSize: 11),
                          textAlign: TextAlign.center),
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

class _DraftHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: elegantCard(active: true, radius: 16),
      child: Column(
        children: [
          const Icon(Icons.auto_graph, color: kGold, size: 40),
          const SizedBox(height: 10),
          const Text('EL DRAFT',
              style: TextStyle(color: kGold, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Los jugadores compiten en partidos de prueba para establecer el ranking inicial.',
              style: TextStyle(color: kTextSecondary, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DraftStat(label: 'Jugadores', value: '12'),
              const SizedBox(width: 24),
              _DraftStat(label: 'Partidos', value: '6'),
              const SizedBox(width: 24),
              _DraftStat(label: 'Media Técnica', value: '78.4%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DraftStat extends StatelessWidget {
  final String label;
  final String value;
  const _DraftStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: kTeal, fontSize: 18, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 11)),
      ],
    );
  }
}

class _DraftPlayerRow extends StatelessWidget {
  final DraftResult result;
  final bool isCurrentUser;
  const _DraftPlayerRow({required this.result, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: elegantCard(radius: 14, color: isCurrentUser ? kActiveCard : null),
        child: Row(
          children: [
            GoldBadge(number: result.position, size: 28),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 18,
              backgroundColor: kCardBorder,
              child: Text(result.player.name[0],
                  style: const TextStyle(color: kGold, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(result.player.name,
                          style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w800, fontSize: 15)),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.person, color: kTeal, size: 16),
                      ],
                    ],
                  ),
                  Text(result.player.liga,
                      style: const TextStyle(color: kTextSecondary, fontSize: 11)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${result.strikeRate}%',
                    style: const TextStyle(color: kGold, fontSize: 16, fontWeight: FontWeight.w900)),
                Text('Strike Rate', style: const TextStyle(color: kTextSecondary, fontSize: 9)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrialMatchCard extends StatelessWidget {
  final int index;
  final String result;
  const _TrialMatchCard({required this.index, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: elegantCard(radius: 12),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: kTeal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('$index',
                    style: const TextStyle(color: kTeal, fontWeight: FontWeight.w900, fontSize: 13)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(result,
                  style: const TextStyle(color: kTextPrimary, fontSize: 13)),
            ),
            const Icon(Icons.sports_tennis, color: kGold, size: 18),
          ],
        ),
      ),
    );
  }
}
