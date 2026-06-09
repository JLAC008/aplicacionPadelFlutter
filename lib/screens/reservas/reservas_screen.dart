import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => ReservasScreenState();
}

class ReservasScreenState extends State<ReservasScreen> {
  final List<Reserva> _misReservas = List.from(mockReservas);
  DateTime _selectedDate =
      _normalizeDate(DateTime.now().add(const Duration(days: 1)));
  String? _selectedSlot;
  final Set<String> _bookedSlots = {};

  static DateTime _normalizeDate(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  static String _slotKey(DateTime date, String pistaId, String slot) =>
      '${_normalizeDate(date).toIso8601String()}_${pistaId}_$slot';

  @override
  void initState() {
    super.initState();
    for (final r in _misReservas) {
      _bookedSlots.add(_slotKey(r.date, r.pistaId, r.timeSlot));
    }
  }

  String get _dateLabel {
    final d = _selectedDate;
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Hoy';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (d.year == tomorrow.year &&
        d.month == tomorrow.month &&
        d.day == tomorrow.day) {
      return 'Mañana';
    }
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${d.day} ${months[d.month - 1]}';
  }

  void _openBookingSheet(Pista pista) {
    _selectedDate = _normalizeDate(DateTime.now().add(const Duration(days: 1)));
    _selectedSlot = null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingSheet(
        pista: pista,
        selectedDate: _selectedDate,
        selectedSlot: _selectedSlot,
        bookedSlots: _bookedSlots,
        dateLabel: _dateLabel,
        onDateChanged: (d) => setState(() => _selectedDate = d),
        onSlotChanged: (s) => _selectedSlot = s,
        onConfirm: () => _confirmBooking(pista),
      ),
    );
  }

  void _confirmBooking(Pista pista) {
    if (_selectedSlot == null) return;
    final reserva = Reserva(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      pistaId: pista.id,
      pistaName: pista.name,
      date: _selectedDate,
      timeSlot: _selectedSlot!,
      reservedBy: currentUser.name,
    );
    setState(() {
      _misReservas.insert(0, reserva);
      _bookedSlots.add(_slotKey(_selectedDate, pista.id, _selectedSlot!));
    });
    Navigator.pop(context);
    _showCheckmark();
  }

  void _showCheckmark() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: kTeal, size: 22),
            SizedBox(width: 10),
            Text('Pista reservada con éxito',
                style: TextStyle(
                    color: kTextPrimary, fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: kCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cancelReserva(Reserva r) {
    setState(() => _misReservas.removeWhere((x) => x.id == r.id));
  }

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
              const AppTitleBar(title: 'Reservar Pista', showBack: true),
              AppContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_misReservas.isNotEmpty) ...[
                      Text(
                        'Mis Reservas',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: kTextPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(_misReservas.length, (i) {
                        final r = _misReservas[i];
                        return _ReservaCard(
                          reserva: r,
                          onCancel: () => _cancelReserva(r),
                        )
                            .animate()
                            .fadeIn(
                              duration: 300.ms,
                              delay: (80 * i).ms,
                              curve: Curves.easeOutCubic,
                            )
                            .slideX(
                              begin: 0.15,
                              end: 0,
                              duration: 300.ms,
                              delay: (80 * i).ms,
                              curve: Curves.easeOutCubic,
                            );
                      }),
                      const SizedBox(height: 24),
                    ],
                    Text(
                      'Pistas Disponibles',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: kTextPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 10),
                    PadelFadeInList(
                      itemCount: mockPistas.length,
                      itemBuilder: (i) => _PistaCard(
                        pista: mockPistas[i],
                        onTap: () => _openBookingSheet(mockPistas[i]),
                      ),
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

class _ReservaCard extends StatelessWidget {
  final Reserva reserva;
  final VoidCallback onCancel;
  const _ReservaCard({required this.reserva, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final day = reserva.date.day.toString().padLeft(2, '0');
    final month = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ][reserva.date.month - 1];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: elegantCard(
        radius: 16,
        active: true,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kGold, kGoldDark],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(day,
                    style: const TextStyle(
                        color: kOnGold,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                Text(month,
                    style: const TextStyle(
                        color: kOnGold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reserva.pistaName,
                    style: const TextStyle(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(reserva.timeSlot,
                    style: const TextStyle(color: kTeal, fontSize: 13)),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onCancel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PistaCard extends StatelessWidget {
  final Pista pista;
  final VoidCallback onTap;
  const _PistaCard({required this.pista, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 170,
          decoration: elegantCard(radius: 20),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LocalOrNetworkImage(
                source: pista.imageUrl,
                fit: BoxFit.cover,
                fallback: Container(
                  color: kActiveCard,
                  child:
                      const Icon(Icons.sports_tennis, color: kGold, size: 40),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.70),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pista.name,
                            style: const TextStyle(
                              color: kTextPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: pista.indoor
                                ? kTeal.withOpacity(0.2)
                                : kGold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            pista.indoor ? 'Indoor' : 'Outdoor',
                            style: TextStyle(
                              color: pista.indoor ? kTeal : kGold,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: kTextSecondary, size: 13),
                        const SizedBox(width: 3),
                        Text(pista.location,
                            style: const TextStyle(
                                color: kTextSecondary, fontSize: 12)),
                        const Spacer(),
                        Text(
                          '${pista.pricePerHour.toInt()}€/h',
                          style: const TextStyle(
                              color: kGold,
                              fontSize: 14,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: pista.amenities
                          .take(3)
                          .map((a) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(a,
                                    style: const TextStyle(
                                        color: kTextSecondary, fontSize: 10)),
                              ))
                          .toList(),
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

class _BookingSheet extends StatefulWidget {
  final Pista pista;
  final DateTime selectedDate;
  final String? selectedSlot;
  final Set<String> bookedSlots;
  final String dateLabel;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String?> onSlotChanged;
  final VoidCallback onConfirm;

  const _BookingSheet({
    required this.pista,
    required this.selectedDate,
    required this.selectedSlot,
    required this.bookedSlots,
    required this.dateLabel,
    required this.onDateChanged,
    required this.onSlotChanged,
    required this.onConfirm,
  });

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  late DateTime _date;
  String? _slot;

  static const _allSlots = [
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
    '18:00 - 19:00',
    '19:00 - 20:00',
    '20:00 - 21:00',
    '21:00 - 22:00',
  ];

  @override
  void initState() {
    super.initState();
    _date = widget.selectedDate;
  }

  bool _isSlotBooked(String slot) {
    return widget.bookedSlots
        .contains(ReservasScreenState._slotKey(_date, widget.pista.id, slot));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kCardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kGold, kTeal],
                  ),
                ),
                child:
                    const Icon(Icons.sports_tennis, color: kOnGold, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.pista.name,
                        style: const TextStyle(
                            color: kTextPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                    Text(
                        '${widget.pista.pricePerHour.toInt()}€/h · ${widget.pista.location}',
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Selecciona fecha',
              style: TextStyle(
                  color: kTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(14, (i) {
                final d = DateTime.now().add(Duration(days: i + 1));
                final isSelected = d.day == _date.day &&
                    d.month == _date.month &&
                    d.year == _date.year;
                final label = i == 0 ? 'Mañana' : '${d.day}/${d.month}';
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _date = d;
                        _slot = null;
                      });
                      widget.onDateChanged(d);
                      widget.onSlotChanged(null);
                    },
                    child: AnimatedContainer(
                      duration: 200.ms,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? kGold : kActiveCard,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? kGold : kCardBorder,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? kOnGold : kTextPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Selecciona hora',
              style: TextStyle(
                  color: kTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allSlots.map((slot) {
              final isSelected = _slot == slot;
              final booked = _isSlotBooked(slot);
              return GestureDetector(
                onTap: booked
                    ? null
                    : () {
                        setState(() => _slot = slot);
                        widget.onSlotChanged(slot);
                      },
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: booked
                        ? kCardBorder.withOpacity(0.3)
                        : isSelected
                            ? kGold
                            : kActiveCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: booked
                          ? Colors.transparent
                          : isSelected
                              ? kGold
                              : kCardBorder,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      color: booked
                          ? kTextSecondary.withOpacity(0.4)
                          : isSelected
                              ? kOnGold
                              : kTextPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      decoration: booked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _slot == null ? null : widget.onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                foregroundColor: kOnGold,
                disabledBackgroundColor: kCardBorder,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              child: const Text('Confirmar Reserva'),
            ),
          ),
        ],
      ),
    );
  }
}
