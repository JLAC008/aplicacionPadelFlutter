import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../ligas/liga_detail_screen.dart';
import '../main_navigation.dart';
import '../reservas/reservas_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completed = mockChallenges
        .where((challenge) => challenge.status == ChallengeStatus.completed)
        .take(2)
        .toList();

    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 104),
          child: Column(
            children: [
              const AppTitleBar(),
              AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HomeHero(),
                    const SizedBox(height: 14),
                    const _QuickActions(),
                    const SizedBox(height: 24),
                    const Text(
                      'Mi actividad',
                      style: TextStyle(
                        color: kTextPrimary,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActivityCard(
                      icon: Icons.calendar_month_outlined,
                      title: 'Próximo partido',
                      subtitle: 'Sábado, 7 Jun · 11:00 vs Bere & Mati',
                      onTap: () => _switchTab(context, 1),
                    ),
                    _ActivityCard(
                      icon: Icons.emoji_events_outlined,
                      title: 'Resultados de liga',
                      subtitle: 'Liga Peso Pesado · Posición #1',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LigaDetailScreen(liga: ligaPesoPesado),
                        ),
                      ),
                    ),
                    _ActivityCard(
                      icon: Icons.stacked_line_chart,
                      title: 'Actividad Padel Band',
                      subtitle: 'Puntuación 8.50 · Ranking #1',
                      onTap: () => _switchTab(context, 2),
                    ),
                    _ActivityCard(
                      icon: Icons.sports_tennis,
                      title: 'Reservar pista',
                      subtitle: 'Elige fecha y hora para jugar',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReservasScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Últimos partidos',
                      style: TextStyle(
                        color: kTextPrimary,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...completed
                        .map((challenge) => _MatchCard(challenge: challenge)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _switchTab(BuildContext context, int index) {
    context.findAncestorStateOfType<MainNavigationState>()?.switchToTab(index);
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: Container(
        decoration: elegantCard(active: true, radius: 16),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const LocalOrNetworkImage(source: kHeroPlayerImage),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x33000000),
                    Color(0xD9000000),
                  ],
                ),
              ),
            ),
            const Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DOMINA LA PISTA',
                    style: TextStyle(
                      color: kGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Tu próxima victoria empieza aquí',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  static const _items = [
    (Icons.sports_tennis, 'JUGAR', 1),
    (Icons.leaderboard_outlined, 'RANKING', 2),
    (Icons.shopping_bag_outlined, 'TIENDA', 3),
    (Icons.person_outline, 'PERFIL', 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_items.length, (index) {
        final item = _items[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == _items.length - 1 ? 0 : 8),
            child: InkWell(
              key: Key('home-tab-${item.$3}'),
              onTap: () => HomeScreen._switchTab(context, item.$3),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 74,
                decoration: elegantCard(radius: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.$1, color: index == 0 ? kTeal : kGold, size: 25),
                    const SizedBox(height: 7),
                    FittedBox(
                      child: Text(
                        item.$2,
                        style: const TextStyle(
                          color: kTextPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: elegantCard(radius: 14),
          child: Row(
            children: [
              Icon(icon, color: kGold, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: kTextPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kTextSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Challenge challenge;

  const _MatchCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: elegantCard(radius: 14),
      child: Row(
        children: [
          PairAvatars(
            url1: challenge.challenger.player1.avatarUrl,
            url2: challenge.challenger.player2.avatarUrl,
            radius: 19,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${challenge.challenger.player1.name} & '
                  '${challenge.challenger.player2.name}',
                  style: const TextStyle(
                    color: kTextPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'vs ${challenge.challenged.player1.name} & '
                  '${challenge.challenged.player2.name}',
                  style: const TextStyle(color: kTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${challenge.scoreChallenger ?? '-'} - '
            '${challenge.scoreChallenged ?? '-'}',
            style: const TextStyle(
              color: kGold,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
