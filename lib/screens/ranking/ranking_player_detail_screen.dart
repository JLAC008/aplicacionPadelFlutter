import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/common_widgets.dart';
import '../../models/models.dart';

class RankingPlayerDetailScreen extends StatefulWidget {
  final PadelBandRanking entry;
  const RankingPlayerDetailScreen({super.key, required this.entry});

  @override
  State<RankingPlayerDetailScreen> createState() =>
      _RankingPlayerDetailScreenState();
}

class _RankingPlayerDetailScreenState
    extends State<RankingPlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(entry.player.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Hero(
                tag: 'player_${entry.player.id}',
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_pulseController.value * 0.03),
                      child: child,
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 123,
                        height: 123,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [kGold, kTeal],
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: kGold.withOpacity(0.3),
                                blurRadius: 24,
                                spreadRadius: 2)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: entry.player.avatarUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: kCard,
                                child: Icon(Icons.person,
                                    color: kTextSecondary,
                                    size: 60),
                              ),
                              placeholder: (_, __) =>
                                  Container(color: kCardBorder),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -6,
                        left: -6,
                        child:
                            GoldBadge(number: entry.rank, size: 32),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              entry.player.name,
              style: const TextStyle(
                  color: kTextPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(entry.player.liga,
                style:
                    TextStyle(color: kTextSecondary, fontSize: 14)),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: kGold, blurRadius: 24, spreadRadius: -8),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield, color: kGold, size: 28),
                  const SizedBox(width: 10),
                  AnimatedCountText(
                    value: entry.score,
                    decimals: 2,
                    style: const TextStyle(
                        color: kGold,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('Padel',
                          style: TextStyle(
                              color: kTextSecondary,
                              fontSize: 11)),
                      Text('Band',
                          style: TextStyle(
                              color: kTextSecondary,
                              fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _StatCard(
                    label: 'Partidos',
                    value: '${entry.matchesPlayed}',
                    icon: Icons.sports_tennis),
                const SizedBox(width: 10),
                _StatCard(
                    label: 'Victorias',
                    value: '${entry.wins}',
                    icon: Icons.emoji_events,
                    color: kGold),
                const SizedBox(width: 10),
                _StatCard(
                    label: 'Derrotas',
                    value: '${entry.losses}',
                    icon: Icons.close,
                    color: Colors.red),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text('Tasa de victorias',
                      style: TextStyle(
                          color: kTextSecondary,
                          fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: entry.matchesPlayed > 0
                                ? entry.wins /
                                    entry.matchesPlayed
                                : 0,
                            backgroundColor: kCardBorder,
                            valueColor:
                                const AlwaysStoppedAnimation<
                                    Color>(kGold),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          AnimatedCountText(
                            value: entry.matchesPlayed > 0
                                ? (entry.wins /
                                        entry.matchesPlayed) *
                                    100
                                : 0,
                            decimals: 0,
                            style: const TextStyle(
                                color: kGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const Text(
                            '%',
                            style: TextStyle(
                                color: kGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                children: [
                  _InfoRow(
                      icon: Icons.military_tech,
                      label: 'Nivel',
                      value: entry.player.level),
                  Divider(color: kCardBorder.withOpacity(0.3), height: 24),
                  _InfoRow(
                      icon: Icons.emoji_events,
                      label: 'Liga',
                      value: entry.player.liga),
                  Divider(color: kCardBorder.withOpacity(0.3), height: 24),
                  _InfoRow(
                    icon: Icons.leaderboard,
                    label: 'Ranking Padel Band',
                    value: '#${entry.rank}',
                    valueColor: kGold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      this.color = kTeal});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 12),
         decoration: BoxDecoration(
           color: kCard,
           borderRadius: BorderRadius.circular(16),
           boxShadow: [
             BoxShadow(color: kShadowColor.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4)),
           ],
         ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: kTextSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: kTeal, size: 20),
        const SizedBox(width: 12),
        Text(label,
            style:
                TextStyle(color: kTextSecondary, fontSize: 14)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ],
    );
  }
}
