import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import 'ranking_player_detail_screen.dart';

class RankingIndividualScreen extends StatelessWidget {
  const RankingIndividualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Ranking Individual'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: PadelFadeInList(
          itemCount: padelBandRanking.length,
          itemBuilder: (i) {
            final entry = padelBandRanking[i];
            return _IndividualRow(
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
    );
  }
}

class _IndividualRow extends StatefulWidget {
  final PadelBandRanking entry;
  final VoidCallback onTap;

  const _IndividualRow({required this.entry, required this.onTap});

  @override
  State<_IndividualRow> createState() => _IndividualRowState();
}

class _IndividualRowState extends State<_IndividualRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final isCurrentUser = entry.player.id == currentUser.id;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
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
                width: 32,
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
                                color: kTextSecondary, size: 22),
                          ),
                          placeholder: (_, __) =>
                              Container(color: kCardBorder),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: GoldBadge(number: entry.rank, size: 20),
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
                            child: const Text(
                              'Tú',
                              style: TextStyle(
                                color: kGold,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${entry.wins}V / ${entry.losses}D • ${entry.matchesPlayed} partidos',
                      style:
                          TextStyle(color: kTextSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entry.score.toStringAsFixed(1),
                    style: const TextStyle(
                      color: kGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text('pts',
                      style:
                          TextStyle(color: kTextSecondary, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
