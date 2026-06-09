import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import 'ranking_padel_band_screen.dart';
import 'ranking_individual_screen.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              const AppTitleBar(title: 'Ranking'),
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 10, 18, 0),
                child: HeroImagePanel(height: 300),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                child: PadelFadeInList(
                  itemCount: 3,
                  itemBuilder: (i) {
                    return [
                      _RankingOptionCard(
                        icon: Icons.groups_outlined,
                        iconColor: kTeal,
                        title: 'Ranking por Pareja',
                        subtitle: 'Club Club',
                        onTap: () => _showComingSoon(context),
                      ),
                      _RankingOptionCard(
                        icon: Icons.person_outline,
                        iconColor: kGold,
                        title: 'Ranking Individual',
                        subtitle: 'Clasificación por jugador',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const RankingIndividualScreen()),
                        ),
                        isHighlighted: true,
                      ),
                      _RankingOptionCard(
                        badge: '8.00',
                        title: 'Ranking Padel Band',
                        subtitle: 'Smash Club',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const RankingPadelBandScreen()),
                        ),
                      ),
                    ][i];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: const Text('Próximamente disponible'),
          backgroundColor: kCard),
    );
  }
}

class _RankingOptionCard extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String? badge;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _RankingOptionCard({
    this.icon,
    this.iconColor,
    this.badge,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 86,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: elegantCard(
            active: isHighlighted,
            radius: 20,
          ),
          child: Row(
            children: [
              _LeadingWidget(
                  icon: icon, iconColor: iconColor, badge: badge),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: kTextPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: TextStyle(
                            color: kTextSecondary, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: kGold, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadingWidget extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String? badge;

  const _LeadingWidget({this.icon, this.iconColor, this.badge});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Icon(icon!, color: iconColor ?? kTeal, size: 32);
    }

    return PadelBandBadge(
        score: double.tryParse(badge ?? '8') ?? 8, width: 54);
  }
}
