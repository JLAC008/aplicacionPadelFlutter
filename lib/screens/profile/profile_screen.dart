import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = _MockProfile.fromCurrentUser();

    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTitleBar(title: 'Player Profile'),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _section(0, _ProfileHero(profile: profile)),
                    const SizedBox(height: 14),
                    _section(1, Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.military_tech,
                            label: 'Nivel',
                            value: profile.level,
                            color: kTeal,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.emoji_events,
                            label: 'Liga',
                            value: profile.league,
                            color: kGold,
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 14),
                    _section(2, _PartnerCard(profile: profile)),
                    const SizedBox(height: 14),
                    _section(3, _AvailabilityCard(profile: profile)),
                    const SizedBox(height: 14),
                    _section(4, _PerformanceCard(profile: profile)),
                    const SizedBox(height: 14),
                    _section(5, _NextMatchCard(profile: profile)),
                    const SizedBox(height: 14),
                    _section(6, _AchievementCard(profile: profile), scale: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(int index, Widget child, {bool scale = false}) {
    var anim = child
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: (80 * index).ms,
          curve: Curves.easeOutCubic,
        )
        .slideY(
          begin: 0.15,
          end: 0,
          duration: 400.ms,
          delay: (80 * index).ms,
          curve: Curves.easeOutCubic,
        );
    if (scale) {
      anim = anim.scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1.0, 1.0),
        duration: 500.ms,
        delay: (80 * index).ms,
        curve: Curves.elasticOut,
      );
    }
    return anim;
  }
}

class _MockProfile {
  final Player player;
  final Pair pair;
  final String club;
  final String level;
  final String league;
  final String partnerName;
  final String teamName;
  final String nextMatch;
  final String nextMatchDate;
  final String achievement;
  final int matches;
  final int wins;
  final int losses;
  final List<String> availability;

  const _MockProfile({
    required this.player,
    required this.pair,
    required this.club,
    required this.level,
    required this.league,
    required this.partnerName,
    required this.teamName,
    required this.nextMatch,
    required this.nextMatchDate,
    required this.achievement,
    required this.matches,
    required this.wins,
    required this.losses,
    required this.availability,
  });

  factory _MockProfile.fromCurrentUser() {
    final ranking = padelBandRanking.firstWhere(
      (entry) => entry.player.id == currentUser.id,
      orElse: () => PadelBandRanking(
        player: currentUser,
        rank: 1,
        score: 8.5,
        matchesPlayed: 12,
        wins: 9,
        losses: 3,
      ),
    );
    final mate = currentUserPair.player1.id == currentUser.id
        ? currentUserPair.player2
        : currentUserPair.player1;

    return _MockProfile(
      player: currentUser,
      pair: currentUserPair,
      club: 'Smash Club',
      level: currentUser.level,
      league: currentUser.liga,
      partnerName: mate.name,
      teamName: currentUserPair.teamName ?? 'Juan & Pedro',
      nextMatch: 'Juan & Pedro vs Bere & Mati',
      nextMatchDate: 'Sábado, 7 Jun · 11:00',
      achievement: 'Campeón provisional Peso Pesado',
      matches: ranking.matchesPlayed,
      wins: ranking.wins,
      losses: ranking.losses,
      availability: const ['Noches', 'Fin de semana', 'Flexible'],
    );
  }
}

class _ProfileHero extends StatefulWidget {
  final _MockProfile profile;
  const _ProfileHero({required this.profile});

  @override
  State<_ProfileHero> createState() => _ProfileHeroState();
}

class _ProfileHeroState extends State<_ProfileHero>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowScale;
  late Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _glowScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.04), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.0), weight: 1),
    ]).animate(_controller);
    _glowOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 0.6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 0.3), weight: 1),
    ]).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final winRate = widget.profile.matches == 0
        ? 0
        : ((widget.profile.wins / widget.profile.matches) * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: elegantCard(active: true, radius: 20),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Transform.scale(
                    scale: _glowScale.value,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            kGold.withOpacity(_glowOpacity.value * 0.7),
                            kTeal.withOpacity(_glowOpacity.value * 0.4),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kGold.withOpacity(_glowOpacity.value * 0.3),
                            blurRadius: 28,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SingleAvatar(
                url: widget.profile.player.avatarUrl,
                radius: 44,
                badge: GoldBadge(number: widget.profile.player.padelBandRank, size: 26),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.profile.player.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  'CLUB: ${widget.profile.club}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Played: ', style: TextStyle(color: kTeal, fontSize: 13, fontWeight: FontWeight.w800)),
                    AnimatedCountText(value: widget.profile.matches.toDouble(), style: TextStyle(color: kTeal, fontSize: 13, fontWeight: FontWeight.w800)),
                    Text(' (W:', style: TextStyle(color: kTeal, fontSize: 13, fontWeight: FontWeight.w800)),
                    AnimatedCountText(value: widget.profile.wins.toDouble(), style: TextStyle(color: kTeal, fontSize: 13, fontWeight: FontWeight.w800)),
                    Text(', L:', style: TextStyle(color: kTeal, fontSize: 13, fontWeight: FontWeight.w800)),
                    AnimatedCountText(value: widget.profile.losses.toDouble(), style: TextStyle(color: kTeal, fontSize: 13, fontWeight: FontWeight.w800)),
                    Text(')', style: TextStyle(color: kTeal, fontSize: 13, fontWeight: FontWeight.w800)),
                  ],
                ),
                Row(
                  children: [
                    Text('Win Rate: ', style: TextStyle(color: kGold, fontSize: 13, fontWeight: FontWeight.w800)),
                    AnimatedCountText(value: winRate.toDouble(), style: TextStyle(color: kGold, fontSize: 13, fontWeight: FontWeight.w800)),
                    Text('%', style: TextStyle(color: kGold, fontSize: 13, fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          PadelBandBadge(score: widget.profile.player.padelBandScore),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.all(14),
      decoration: elegantCard(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final _MockProfile profile;
  const _PartnerCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: elegantCard(radius: 20),
      child: Row(
        children: [
          PairAvatars(
            url1: profile.pair.player1.avatarUrl,
            url2: profile.pair.player2.avatarUrl,
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pareja de equipo',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 3),
                Text(
                  profile.teamName,
                  style: TextStyle(
                    color: kTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Compañero: ${profile.partnerName}',
                  style: TextStyle(
                    color: kTeal,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedCountText(value: profile.pair.wins.toDouble(), style: TextStyle(color: kGold, fontWeight: FontWeight.w900)),
              const Text('W / ', style: TextStyle(color: kGold, fontWeight: FontWeight.w900)),
              AnimatedCountText(value: profile.pair.losses.toDouble(), style: TextStyle(color: kGold, fontWeight: FontWeight.w900)),
              const Text('L', style: TextStyle(color: kGold, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  final _MockProfile profile;
  const _AvailabilityCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: elegantCard(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disponibilidad horaria',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.availability
                .map((slot) => StatusChip(
                      label: slot,
                      color: slot == 'Fin de semana' ? kGold : kTeal,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final _MockProfile profile;
  const _PerformanceCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: elegantCard(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance',
            style: TextStyle(
                color: kGold, fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          _StatLine(
            label: 'Partidos',
            value: '${profile.matches}',
            animatedValue: profile.matches.toDouble(),
            detail: 'W:${profile.wins}, L:${profile.losses}',
            color: kTeal,
          ),
          _StatLine(
            label: 'Ranking',
            value: profile.player.padelBandScore.toStringAsFixed(2),
            animatedValue: profile.player.padelBandScore,
            detail: '(Pos: #${profile.player.padelBandRank})',
            color: kGold,
          ),
          _StatLine(
            label: 'Liga activa',
            value: profile.league,
            detail: '',
            color: kTextPrimary,
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;
  final double? animatedValue;
  final String detail;
  final Color color;
  const _StatLine({
    required this.label,
    this.value = '',
    this.animatedValue,
    this.detail = '',
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Text('$label:', style: TextStyle(color: kTextSecondary)),
          ),
          Expanded(
            child: animatedValue != null
                ? Row(
                    children: [
                      AnimatedCountText(value: animatedValue!, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
                      if (detail.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(detail, style: TextStyle(color: kTextSecondary)),
                        ),
                    ],
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: value,
                          style: TextStyle(color: color, fontWeight: FontWeight.w900),
                        ),
                        if (detail.isNotEmpty)
                          TextSpan(
                            text: ' $detail',
                            style: TextStyle(color: kTextSecondary),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NextMatchCard extends StatelessWidget {
  final _MockProfile profile;
  const _NextMatchCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: elegantCard(radius: 20),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: kGold, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próximo partido',
                  style: TextStyle(
                    color: kTextPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(profile.nextMatch,
                    style: TextStyle(color: kTextSecondary, fontSize: 13)),
                Text(profile.nextMatchDate,
                    style: TextStyle(
                        color: kTeal,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final _MockProfile profile;
  const _AchievementCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: elegantCard(active: true, radius: 20),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: kGold, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.achievement,
                  style: TextStyle(
                    color: kTextPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Padel Fighter League - 2024',
                  style: TextStyle(color: kTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
