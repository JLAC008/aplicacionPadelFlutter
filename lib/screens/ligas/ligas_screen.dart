import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import 'liga_detail_screen.dart';

class LigasScreen extends StatelessWidget {
  const LigasScreen({super.key});

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
              const AppTitleBar(title: 'Ligas', showBack: true),
              AppContent(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  children: [
                    const HeroImagePanel(height: 190, imageUrl: kCourtImage),
                    const SizedBox(height: 20),
                    _LigaCategory(
                      title: 'Peso Pesado',
                      trailingIcon: Icons.fitness_center,
                      liga: ligaPesoPesado,
                      active: true,
                    ),
                    _LigaCategory(
                      title: 'Peso Welter',
                      trailingIcon: Icons.keyboard_arrow_down,
                      liga: ligaPesoMedio,
                    ),
                    _LigaCategory(
                      title: 'Peso Ligero',
                      leadingIcon: Icons.sports_mma,
                      trailingIcon: Icons.keyboard_arrow_down,
                      liga: ligaPesoLigero,
                    ),
                    _LigaCategory(
                      title: 'Peso Gallo',
                      trailingIcon: Icons.keyboard_arrow_down,
                      liga: ligaPesoGallo,
                    ),
                    _LigaCategory(
                      title: 'Mosca',
                      leadingIcon: Icons.directions_run,
                      trailingIcon: Icons.bug_report,
                      liga: ligaPesoMosca,
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

class _LigaCategory extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final IconData trailingIcon;
  final Liga? liga;
  final bool active;

  const _LigaCategory({
    required this.title,
    this.leadingIcon,
    required this.trailingIcon,
    required this.liga,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: liga == null
            ? null
            : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LigaDetailScreen(liga: liga!)),
                ),
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: elegantCard(
            active: active,
            radius: 14,
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: kGold, size: 28),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: kTextPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (liga != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    '${liga!.pairs.length}',
                    style: TextStyle(color: kTextSecondary, fontSize: 13),
                  ),
                ),
              Icon(trailingIcon,
                  color: active ? kGold : kTextSecondary, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
