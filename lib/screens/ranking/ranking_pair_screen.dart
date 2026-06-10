import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';

class RankingPairScreen extends StatelessWidget {
  const RankingPairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pairs = allLigas
        .expand((l) => l.pairs)
        .toList()
      ..sort((a, b) {
        final aScore = a.wins / (a.wins + a.losses).clamp(1, double.infinity);
        final bScore = b.wins / (b.wins + b.losses).clamp(1, double.infinity);
        if (bScore != aScore) return bScore.compareTo(aScore);
        return b.wins.compareTo(a.wins);
      });

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Ranking por Pareja'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: PadelFadeInList(
          itemCount: pairs.length,
          itemBuilder: (i) {
            final pair = pairs[i];
            final rank = i + 1;
            final matches = pair.wins + pair.losses;
            final score = matches > 0
                ? (pair.wins / matches * 10)
                : 0.0;
            final isCurrentUserPair =
                pair.player1.id == currentUser.id ||
                    pair.player2.id == currentUser.id;

            return _PairRow(
              pair: pair,
              rank: rank,
              score: score,
              matches: matches,
              isCurrentUserPair: isCurrentUserPair,
            );
          },
        ),
      ),
    );
  }
}

class _PairRow extends StatefulWidget {
  final Pair pair;
  final int rank;
  final double score;
  final int matches;
  final bool isCurrentUserPair;

  const _PairRow({
    required this.pair,
    required this.rank,
    required this.score,
    required this.matches,
    required this.isCurrentUserPair,
  });

  @override
  State<_PairRow> createState() => _PairRowState();
}

class _PairRowState extends State<_PairRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final pair = widget.pair;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isCurrentUserPair
                ? kGold.withOpacity(0.08)
                : kCard,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: kShadowColor.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
              if (widget.isCurrentUserPair)
                BoxShadow(
                    color: kGold.withOpacity(0.12),
                    blurRadius: 20,
                    spreadRadius: 0),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  '${widget.rank}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.rank <= 3 ? kGold : kTextSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.rank <= 3 ? 16 : 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _PairAvatars(
                url1: pair.player1.avatarUrl,
                url2: pair.player2.avatarUrl,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pair.teamName ??
                                '${pair.player1.name} & ${pair.player2.name}',
                            style: TextStyle(
                              color: widget.isCurrentUserPair
                                  ? kGold
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.isCurrentUserPair) ...[
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
                      '${pair.wins}V / ${pair.losses}D • ${widget.matches} partidos',
                      style: const TextStyle(color: kTextSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.score.toStringAsFixed(1),
                    style: const TextStyle(
                      color: kGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Text('pts',
                      style: TextStyle(color: kTextSecondary, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PairAvatars extends StatelessWidget {
  final String url1;
  final String url2;

  const _PairAvatars({required this.url1, required this.url2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 51,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            child: _avatar(url2, 22),
          ),
          Positioned(
            left: 22,
            child: _avatar(url1, 22),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String url, double r) {
    return Container(
      width: r * 2 + 3,
      height: r * 2 + 3,
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
            imageUrl: url,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
              color: kCardBorder,
              child: Icon(Icons.person, color: kTextSecondary, size: 18),
            ),
            placeholder: (_, __) => Container(color: kCardBorder),
          ),
        ),
      ),
    );
  }
}
