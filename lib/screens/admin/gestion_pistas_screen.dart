import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';

class GestionPistasScreen extends StatefulWidget {
  const GestionPistasScreen({super.key});

  @override
  State<GestionPistasScreen> createState() => _GestionPistasScreenState();
}

class _GestionPistasScreenState extends State<GestionPistasScreen> {
  void _addPista() {
    _showForm(null);
  }

  void _editPista(Pista pista) {
    _showForm(pista);
  }

  void _deletePista(Pista pista) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCard,
        title: const Text('Eliminar pista', style: TextStyle(color: kGold)),
        content: Text('¿Eliminar "${pista.name}"?', style: const TextStyle(color: kTextPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: kTextSecondary)),
          ),
          TextButton(
            onPressed: () {
              mockPistas.remove(pista);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showForm(Pista? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final locationCtrl = TextEditingController(text: existing?.location ?? '');
    final priceCtrl = TextEditingController(text: existing?.pricePerHour.toString() ?? '');
    final amenitiesCtrl = TextEditingController(text: existing?.amenities.join(', ') ?? '');
    bool indoor = existing?.indoor ?? false;

    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (_, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: kCardBorder, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(existing == null ? 'Añadir Pista' : 'Editar Pista',
                  style: const TextStyle(color: kGold, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              _Field(label: 'Nombre', controller: nameCtrl),
              const SizedBox(height: 12),
              _Field(label: 'Ubicación', controller: locationCtrl),
              const SizedBox(height: 12),
              _Field(label: 'Precio por hora (€)', controller: priceCtrl, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _Field(label: 'Servicios (separados por coma)', controller: amenitiesCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Interior', style: TextStyle(color: kTextPrimary)),
                  const Spacer(),
                  Switch(
                    value: indoor,
                    activeColor: kTeal,
                    onChanged: (v) => setSheetState(() => indoor = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final location = locationCtrl.text.trim();
                    final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
                    if (name.isEmpty || location.isEmpty || price <= 0) return;

                    final amenities = amenitiesCtrl.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    if (existing == null) {
                      mockPistas.add(Pista(
                        id: 'pista_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        imageUrl: 'assets/images/generated/court-night.png',
                        location: location,
                        amenities: amenities,
                        indoor: indoor,
                        pricePerHour: price,
                      ));
                    } else {
                      final idx = mockPistas.indexOf(existing);
                      if (idx >= 0) {
                        mockPistas[idx] = Pista(
                          id: existing.id,
                          name: name,
                          imageUrl: existing.imageUrl,
                          location: location,
                          amenities: amenities,
                          indoor: indoor,
                          pricePerHour: price,
                        );
                      }
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kTeal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(existing == null ? 'Añadir' : 'Guardar',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
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
            const AppTitleBar(title: 'Gestión de Pistas', showBack: true),
            Expanded(
              child: mockPistas.isEmpty
                  ? const Center(child: Text('No hay pistas', style: TextStyle(color: kTextSecondary)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                      itemCount: mockPistas.length,
                      itemBuilder: (_, i) {
                        final pista = mockPistas[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: elegantCard(radius: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 48, height: 48,
                                  decoration: BoxDecoration(
                                    color: pista.indoor ? kTeal.withValues(alpha: 0.15) : kGold.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(pista.indoor ? Icons.roofing : Icons.wb_sunny,
                                      color: pista.indoor ? kTeal : kGold, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(pista.name,
                                          style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w800, fontSize: 15)),
                                      Text(pista.location,
                                          style: const TextStyle(color: kTextSecondary, fontSize: 12)),
                                      Text('${pista.pricePerHour.toStringAsFixed(0)}€/h · ${pista.amenities.length} servicios',
                                          style: const TextStyle(color: kTextSecondary, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: kTeal, size: 20),
                                  onPressed: () => _editPista(pista),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                  onPressed: () => _deletePista(pista),
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
        onPressed: _addPista,
        backgroundColor: kGold,
        child: const Icon(Icons.add, color: kOnGold),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _Field({required this.label, required this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: kTextPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTextSecondary),
        filled: true,
        fillColor: kBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
