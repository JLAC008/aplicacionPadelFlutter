import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import 'gestion_pistas_screen.dart';
import '../torneo/regular_season_screen.dart';
import '../torneo/repechage_screen.dart';
import '../torneo/championship_screen.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!currentAppUser.isAdmin) {
      return Scaffold(
        backgroundColor: kBg,
        body: const Center(child: Text('Acceso denegado', style: TextStyle(color: kTextSecondary))),
      );
    }

    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTitleBar(title: 'Panel Admin', showBack: true),
              AppContent(
                child: Column(
                  children: [
                    _AdminCard(
                      icon: Icons.sports_tennis,
                      title: 'Gestión de Pistas',
                      subtitle: 'Añadir, editar o eliminar pistas',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GestionPistasScreen())),
                    ),
                    const SizedBox(height: 12),
                    _AdminCard(
                      icon: Icons.scoreboard,
                      title: 'Resultados - Liga Regular',
                      subtitle: 'Editar marcadores de la temporada regular',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegularSeasonScreen())),
                    ),
                    const SizedBox(height: 12),
                    _AdminCard(
                      icon: Icons.swap_horiz,
                      title: 'Resultados - Repesca',
                      subtitle: 'Editar cruces del wildcard round',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RepechageScreen())),
                    ),
                    const SizedBox(height: 12),
                    _AdminCard(
                      icon: Icons.emoji_events,
                      title: 'Resultados - Championship',
                      subtitle: 'Editar cuartos, semis y final',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChampionshipScreen())),
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

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: elegantCard(radius: 18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: kGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: kGold, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: kGold, fontSize: 15, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: kTextSecondary),
          ],
        ),
      ),
    );
  }
}
