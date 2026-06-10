import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../ligas/ligas_screen.dart';
import '../reservas/reservas_screen.dart';
import '../retos/retos_screen.dart';

class PlayHubScreen extends StatelessWidget {
  const PlayHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 104),
          child: Column(
            children: [
              const AppTitleBar(title: 'Jugar'),
              AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeroImagePanel(height: 230, imageUrl: kCourtImage, imageFit: BoxFit.contain),
                    const SizedBox(height: 22),
                    const Text(
                      'Elige cómo quieres jugar',
                      style: TextStyle(
                        color: kTextPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Compite en una liga, gestiona tus retos o reserva pista.',
                      style: TextStyle(color: kTextSecondary),
                    ),
                    const SizedBox(height: 18),
                    _PlayCard(
                      key: const Key('play-leagues'),
                      icon: Icons.emoji_events_outlined,
                      title: 'Ligas',
                      subtitle:
                          'Clasificaciones por categoría y nuevos rivales',
                      color: kGold,
                      onTap: () => _open(context, const LigasScreen()),
                    ),
                    _PlayCard(
                      key: const Key('play-challenges'),
                      icon: Icons.sports_tennis,
                      title: 'Retos',
                      subtitle: 'Partidos programados, resultados y chat',
                      color: kTeal,
                      onTap: () => _open(context, const RetosScreen()),
                    ),
                    _PlayCard(
                      key: const Key('play-bookings'),
                      icon: Icons.calendar_month_outlined,
                      title: 'Reservar pista',
                      subtitle: 'Consulta horarios y confirma tu próxima pista',
                      color: Colors.white,
                      onTap: () => _open(context, const ReservasScreen()),
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

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _PlayCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PlayCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.all(16),
          decoration: elegantCard(radius: 14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: kTextPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kGold),
            ],
          ),
        ),
      ),
    );
  }
}
