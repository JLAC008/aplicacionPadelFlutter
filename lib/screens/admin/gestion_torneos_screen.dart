import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';

class GestionTorneosScreen extends StatefulWidget {
  const GestionTorneosScreen({super.key});

  @override
  State<GestionTorneosScreen> createState() => _GestionTorneosScreenState();
}

class _GestionTorneosScreenState extends State<GestionTorneosScreen> {
  void _createSeason() {
    final nameCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: kCardBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            const Text('Nueva Temporada',
                style: TextStyle(color: kGold, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: kTextPrimary),
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: const TextStyle(color: kTextSecondary),
                filled: true,
                fillColor: kBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  final newSeason = Season(
                    id: 's_${DateTime.now().millisecondsSinceEpoch}',
                    name: name,
                    startDate: DateTime.now(),
                    endDate: DateTime.now().add(const Duration(days: 90)),
                    ligas: [],
                    allMatches: [],
                    jornadaDeadlines: {},
                  );
                  mockSeasons.add(newSeason);
                  mockCurrentSeason = newSeason;
                  Navigator.pop(context);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTeal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Crear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editSeason(Season season) {
    final nameCtrl = TextEditingController(text: season.name);
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: kCardBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            const Text('Editar Temporada',
                style: TextStyle(color: kGold, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: kTextPrimary),
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: const TextStyle(color: kTextSecondary),
                filled: true,
                fillColor: kBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  final idx = mockSeasons.indexWhere((s) => s.id == season.id);
                  if (idx >= 0) {
                    mockSeasons[idx] = Season(
                      id: season.id,
                      name: name,
                      startDate: season.startDate,
                      endDate: season.endDate,
                      ligas: season.ligas,
                      allMatches: season.allMatches,
                      jornadaDeadlines: season.jornadaDeadlines,
                    );
                  }
                  Navigator.pop(context);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTeal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _manageRegistrations(String seasonId) {
    final regs = mockRegistrations.where((r) => r.seasonId == seasonId).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollCtrl) => Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: kCardBorder, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 16),
                Text('Inscripciones (${regs.length})',
                    style: const TextStyle(color: kGold, fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                if (regs.isEmpty)
                  const Expanded(
                    child: Center(child: Text('No hay inscripciones', style: TextStyle(color: kTextSecondary))),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      controller: scrollCtrl,
                      itemCount: regs.length,
                      itemBuilder: (_, i) {
                        final reg = regs[i];
                        final isPending = reg.status == RegistrationStatus.pending;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: elegantCard(radius: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(reg.teamName,
                                          style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w800, fontSize: 15)),
                                    ),
                                    StatusChip(
                                      label: reg.status.name.toUpperCase(),
                                      color: isPending ? Colors.orangeAccent : (reg.status == RegistrationStatus.accepted ? kTeal : Colors.redAccent),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text('${reg.player1.name}${reg.player2 != null ? ' & ${reg.player2!.name}' : ''}${reg.player3 != null ? ' & ${reg.player3!.name}' : ''}',
                                    style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('Inscrito: ${reg.registeredAt.day}/${reg.registeredAt.month}/${reg.registeredAt.year}',
                                    style: const TextStyle(color: kTextSecondary, fontSize: 11)),
                                if (reg.notes != null)
                                  Text('Nota: ${reg.notes}',
                                      style: const TextStyle(color: kGold, fontSize: 11)),
                                if (isPending) ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final idx = mockRegistrations.indexOf(reg);
                                            if (idx >= 0) {
                                              mockRegistrations[idx] = TournamentRegistration(
                                                id: reg.id, seasonId: reg.seasonId,
                                                teamName: reg.teamName,
                                                player1: reg.player1, player2: reg.player2,
                                                player3: reg.player3,
                                                status: RegistrationStatus.accepted,
                                                registeredAt: reg.registeredAt,
                                                notes: reg.notes,
                                              );
                                              setSheetState(() {});
                                              setState(() {});
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kTeal,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: const Text('Aprobar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final idx = mockRegistrations.indexOf(reg);
                                            if (idx >= 0) {
                                              mockRegistrations[idx] = TournamentRegistration(
                                                id: reg.id, seasonId: reg.seasonId,
                                                teamName: reg.teamName,
                                                player1: reg.player1, player2: reg.player2,
                                                player3: reg.player3,
                                                status: RegistrationStatus.rejected,
                                                registeredAt: reg.registeredAt,
                                                notes: reg.notes,
                                              );
                                              setSheetState(() {});
                                              setState(() {});
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: const Text('Rechazar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: Column(
          children: [
            const AppTitleBar(title: 'Gestión de Torneos', showBack: true),
            Expanded(
              child: mockSeasons.isEmpty
                  ? const Center(child: Text('No hay torneos', style: TextStyle(color: kTextSecondary)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                      itemCount: mockSeasons.length,
                      itemBuilder: (_, i) {
                        final season = mockSeasons[i];
                        final regs = mockRegistrations.where((r) => r.seasonId == season.id).toList();
                        final pending = regs.where((r) => r.status == RegistrationStatus.pending).length;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: elegantCard(radius: 14, active: season.id == mockCurrentSeason.id),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(season.name,
                                          style: TextStyle(color: season.id == mockCurrentSeason.id ? kGold : kTextPrimary, fontSize: 16, fontWeight: FontWeight.w900)),
                                    ),
                                    if (season.id == mockCurrentSeason.id)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: kTeal.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text('ACTUAL', style: TextStyle(color: kTeal, fontSize: 9, fontWeight: FontWeight.w900)),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _StatSmall(label: 'Equipos', value: '${regs.where((r) => r.status == RegistrationStatus.accepted).length}'),
                                    const SizedBox(width: 16),
                                    _StatSmall(label: 'Inscritos', value: '${regs.length}'),
                                    const SizedBox(width: 16),
                                    _StatSmall(label: 'Pendientes', value: '$pending', color: pending > 0 ? Colors.orangeAccent : null),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionMiniButton(
                                        icon: Icons.edit,
                                        label: 'Editar',
                                        onTap: () => _editSeason(season),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _ActionMiniButton(
                                        icon: Icons.people,
                                        label: 'Inscripciones ($pending)',
                                        onTap: () => _manageRegistrations(season.id),
                                      ),
                                    ),
                                    if (season.id != mockCurrentSeason.id) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _ActionMiniButton(
                                          icon: Icons.star,
                                          label: 'Activar',
                                          onTap: () {
                                            mockCurrentSeason = season;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createSeason,
        backgroundColor: kGold,
        child: const Icon(Icons.add, color: kOnGold),
      ),
    );
  }
}

class _StatSmall extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _StatSmall({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color ?? kTeal, fontSize: 16, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 10)),
      ],
    );
  }
}

class _ActionMiniButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionMiniButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: kActiveCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kCardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: kGold, size: 18),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(color: kTextSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
