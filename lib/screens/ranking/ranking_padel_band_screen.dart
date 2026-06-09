import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import 'ranking_player_detail_screen.dart';

class RankingPadelBandScreen extends StatelessWidget {
  const RankingPadelBandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Ranking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'PADEL BAND',
              style: const TextStyle(
                color: kGold,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.3, end: 0),
          ),
          _topThreePodium(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: PadelFadeInList(
                itemCount: padelBandRanking.length > 3
                    ? padelBandRanking.length - 3
                    : 0,
                itemBuilder: (i) {
                  final entry = padelBandRanking[i + 3];
                  return _RankingRow(
                    entry: entry,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              RankingPlayerDetailScreen(entry: entry)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kCard,
        child: const Icon(Icons.filter_list, color: kGold),
      ),
    );
  }

  Widget _topThreePodium() {
    final top = padelBandRanking.take(3).toList();
    if (top.length < 3) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _PodiumItem(entry: top[1], height: 110)
                .animate()
                .fadeIn(
                    duration: 350.ms,
                    delay: 0.ms,
                    curve: Curves.easeOutCubic)
                .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 350.ms,
                    delay: 0.ms,
                    curve: Curves.easeOutCubic),
          ),
          Expanded(
            child: _PodiumItem(entry: top[0], height: 140, isFirst: true)
                .animate()
                .fadeIn(
                    duration: 350.ms,
                    delay: 80.ms,
                    curve: Curves.easeOutCubic)
                .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 350.ms,
                    delay: 80.ms,
                    curve: Curves.easeOutCubic),
          ),
          Expanded(
            child: _PodiumItem(entry: top[2], height: 90)
                .animate()
                .fadeIn(
                    duration: 350.ms,
                    delay: 160.ms,
                    curve: Curves.easeOutCubic)
                .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 350.ms,
                    delay: 160.ms,
                    curve: Curves.easeOutCubic),
          ),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final PadelBandRanking entry;
  final double height;
  final bool isFirst;

  const _PodiumItem(
      {required this.entry, required this.height, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isFirst) ...[
          const Icon(Icons.workspace_premium, color: kGold, size: 28),
          const SizedBox(height: 4),
        ],
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: isFirst ? 71 : 61,
              height: isFirst ? 71 : 61,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kGold, kTeal],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: entry.player.avatarUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                        color: kCardBorder,
                        child: Icon(Icons.person,
                            color: kTextSecondary)),
                    placeholder: (_, __) =>
                        Container(color: kCardBorder),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: GoldBadge(number: entry.rank, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(entry.player.name,
            style: const TextStyle(
                color: kTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13),
            textAlign: TextAlign.center),
        Text(entry.score.toStringAsFixed(1),
            style: const TextStyle(
                color: kGold,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 6),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: isFirst ? kGold.withOpacity(0.15) : kCard,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12)),
              boxShadow: [
                BoxShadow(color: kShadowColor.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
          child: Center(
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                color: isFirst ? kGold : kTextSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankingRow extends StatelessWidget {
  final PadelBandRanking entry;
  final VoidCallback onTap;

  const _RankingRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = entry.player.id == currentUser.id;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isCurrentUser ? kGold.withOpacity(0.08) : kCard,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: kShadowColor.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4)),
              if (isCurrentUser)
                BoxShadow(color: kGold.withOpacity(0.12), blurRadius: 20, spreadRadius: 0),
            ],
          ),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(
                '${entry.rank}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: entry.rank <= 3 ? kGold : kTextSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: entry.rank <= 3 ? 16 : 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 51,
                  height: 51,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kGold, kTeal],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: entry.player.avatarUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                            color: kCardBorder,
                            child: Icon(Icons.person,
                                color: kTextSecondary, size: 22)),
                        placeholder: (_, __) =>
                            Container(color: kCardBorder),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: GoldBadge(number: entry.rank, size: 18),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.player.name,
                        style: TextStyle(
                          color: isCurrentUser ? kGold : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: kGold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Tú',
                              style: TextStyle(
                                  color: kGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    entry.player.liga,
                    style:
                        TextStyle(color: kTextSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: kGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kGold.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text('PADEL BAND',
                      style: TextStyle(
                          color: kTextSecondary, fontSize: 8)),
                  Text(
                    entry.score.toStringAsFixed(2),
                    style: const TextStyle(
                        color: kGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
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
