import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import '../chat/chat_screen.dart';

class RetosScreen extends StatefulWidget {
  const RetosScreen({super.key});

  @override
  State<RetosScreen> createState() => _RetosScreenState();
}

class _RetosScreenState extends State<RetosScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
              const AppTitleBar(title: 'Retos', showBack: true),
              AppContent(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeroImagePanel(height: 190, imageUrl: kCourtImage),
                    const SizedBox(height: 20),
                    const Text(
                      'Enfrentamientos programados',
                      style: TextStyle(
                        color: kGold,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Retos entre parejas, resultados y verificaciones pendientes.',
                      style: TextStyle(color: kTextSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    PadelFadeInList(
                      itemCount: mockChallenges.length,
                      itemBuilder: (i) {
                        final c = mockChallenges[i];
                        return _ChallengeCard(
                          challenge: c,
                          isChallengedPair:
                              c.challenged.id == currentUserPair.id,
                          onReject: () => setState(
                              () => c.status = ChallengeStatus.rejected),
                          onAccept: () => setState(
                              () => c.status = ChallengeStatus.accepted),
                          onEnterScore: () => _showEnterScoreDialog(c),
                          onVerify: () => _verifyChallenge(c),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        ),
        child: GoldPillButton(
          icon: Icons.sports_tennis,
          label: 'NUEVO RETO',
          onPressed: _showNewChallengeDialog,
        ),
      ),
    );
  }

  void _verifyChallenge(Challenge challenge) {
    setState(() {
      challenge.status = ChallengeStatus.completed;
      final challengerScore =
          int.tryParse(challenge.scoreChallenger ?? '0') ?? 0;
      final challengedScore =
          int.tryParse(challenge.scoreChallenged ?? '0') ?? 0;
      challenge.challengerWon = challengerScore > challengedScore;

      if (challenge.challengerWon) {
        challenge.challenger.wins += 1;
        challenge.challenged.losses += 1;
      } else {
        challenge.challenged.wins += 1;
        challenge.challenger.losses += 1;
      }

      challenge.challenger.hasCompletedChallenge = true;
      challenge.challenged.hasCompletedChallenge = true;

      final liga = allLigas.firstWhere((l) => l.id == challenge.ligaId);
      final challengerIndex =
          liga.pairs.indexWhere((p) => p.id == challenge.challenger.id);
      if (challengerIndex >= 0 && liga.pairs.isNotEmpty) {
        liga.currentChallengerIndex = (challengerIndex + 1) % liga.pairs.length;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Resultado verificado. ✅ Reto completado.'),
          backgroundColor: Colors.green),
    );
  }

  void _showEnterScoreDialog(Challenge challenge) {
    final challengerController =
        TextEditingController(text: challenge.scoreChallenger ?? '');
    final challengedController =
        TextEditingController(text: challenge.scoreChallenged ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCard,
        title: Text('Registrar Resultado', style: TextStyle(color: kGold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${challenge.challenger.player1.name} & ${challenge.challenger.player2.name}',
              style:
                  TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _ScoreField(
                        controller: challengerController, label: 'Retador')),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('-',
                      style: TextStyle(
                          color: kGold,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: _ScoreField(
                        controller: challengedController, label: 'Retado')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: kTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                challenge.scoreChallenger =
                    challengerController.text.trim().isEmpty
                        ? '0'
                        : challengerController.text.trim();
                challenge.scoreChallenged =
                    challengedController.text.trim().isEmpty
                        ? '0'
                        : challengedController.text.trim();
                challenge.status = ChallengeStatus.awaitingVerification;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Resultado enviado. Esperando verificación.'),
                    backgroundColor: kTeal),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: kTeal),
            child: Text('Confirmar', style: TextStyle(color: kTextPrimary)),
          ),
        ],
      ),
    );
  }

  void _showNewChallengeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _NewChallengeSheet(
        onSend: (challenged) {
          setState(() {
            mockChallenges.add(Challenge(
              id: 'ch_new_${DateTime.now().millisecondsSinceEpoch}',
              challenger: currentUserPair,
              challenged: challenged,
              ligaId: ligaPesoPesado.id,
              ligaName: ligaPesoPesado.name,
              status: ChallengeStatus.pending,
              proposedDate: 'Por acordar',
            ));
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Reto enviado a ${challenged.player1.name} & ${challenged.player2.name}'),
              backgroundColor: kTeal,
            ),
          );
        },
      ),
    );
  }
}

class _ScoreField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _ScoreField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: kTextPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kTextSecondary),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: kCardBorder)),
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: kTeal)),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final bool isChallengedPair;
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final VoidCallback onEnterScore;
  final VoidCallback onVerify;

  const _ChallengeCard({
    required this.challenge,
    required this.isChallengedPair,
    required this.onReject,
    required this.onAccept,
    required this.onEnterScore,
    required this.onVerify,
  });

  Widget _buildCard(BuildContext context) {
    final statusColor = _statusColor(challenge.status);
    final isMyChallenge = challenge.challenger.id == currentUserPair.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: elegantCard(radius: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.sports_tennis, color: kGold, size: 17),
                    const SizedBox(width: 7),
                    Expanded(
                        child: Text(challenge.ligaName,
                            style: TextStyle(
                                color: kTextSecondary, fontSize: 12))),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChatScreen(challenge: challenge)),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.chat_bubble_outline,
                            color: kTeal, size: 16),
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: StatusChip(
                        key: ValueKey(challenge.status),
                        label: _statusLabel(challenge.status),
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                        child: _Team(
                            pair: challenge.challenger, label: 'Retador')),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Text(
                            challenge.scoreChallenger == null
                                ? 'VS'
                                : '${challenge.scoreChallenger} - ${challenge.scoreChallenged}',
                            style: TextStyle(
                                color: kGold,
                                fontWeight: FontWeight.w900,
                                fontSize: 21),
                          ),
                          if (challenge.status == ChallengeStatus.completed)
                            Icon(Icons.check_circle,
                                color: Colors.green.shade400, size: 24),
                        ],
                      ),
                    ),
                    Expanded(
                        child:
                            _Team(pair: challenge.challenged, label: 'Retado')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: kTextSecondary, size: 14),
                    const SizedBox(width: 5),
                    Text(challenge.proposedDate ?? 'Por acordar',
                        style: TextStyle(color: kTextSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: kCardBorder.withOpacity(0.3), height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _Actions(
              challenge: challenge,
              isMyChallenge: isMyChallenge,
              onReject: onReject,
              onAccept: onAccept,
              onEnterScore: onEnterScore,
              onVerify: onVerify,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSwipe =
        challenge.status == ChallengeStatus.pending && isChallengedPair;

    if (!canSwipe) return _buildCard(context);

    return Dismissible(
      key: ValueKey('dismiss_${challenge.id}'),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: kCard,
              title: const Text('Rechazar Reto',
                  style: TextStyle(color: Colors.red)),
              content: const Text('¿Estás seguro de rechazar este reto?',
                  style: TextStyle(color: kTextPrimary)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Rechazar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          );
          if (confirmed == true) onReject();
        } else {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: kCard,
              title: const Text('Aceptar Reto', style: TextStyle(color: kTeal)),
              content: const Text('¿Estás seguro de aceptar este reto?',
                  style: TextStyle(color: kTextPrimary)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Aceptar'),
                  style: ElevatedButton.styleFrom(backgroundColor: kTeal),
                ),
              ],
            ),
          );
          if (confirmed == true) onAccept();
        }
        return false;
      },
      background: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kGold, Color(0xFFC79D31)]),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.check_circle, color: kOnGold, size: 36),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.cancel, color: Colors.white, size: 36),
      ),
      child: _buildCard(context),
    );
  }

  Color _statusColor(ChallengeStatus status) {
    switch (status) {
      case ChallengeStatus.pending:
        return Colors.orange;
      case ChallengeStatus.accepted:
        return kTeal;
      case ChallengeStatus.awaitingVerification:
        return Colors.amber;
      case ChallengeStatus.completed:
        return Colors.green;
      case ChallengeStatus.rejected:
        return Colors.red;
    }
  }

  String _statusLabel(ChallengeStatus status) {
    switch (status) {
      case ChallengeStatus.pending:
        return 'Pendiente';
      case ChallengeStatus.accepted:
        return 'Aceptado';
      case ChallengeStatus.awaitingVerification:
        return 'Por verificar';
      case ChallengeStatus.completed:
        return 'Finalizado ✅';
      case ChallengeStatus.rejected:
        return 'Rechazado';
    }
  }
}

class _Team extends StatelessWidget {
  final Pair pair;
  final String label;
  const _Team({required this.pair, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PairAvatars(
            url1: pair.player1.avatarUrl,
            url2: pair.player2.avatarUrl,
            radius: 20),
        const SizedBox(height: 7),
        Text(
          '${pair.player1.name} & ${pair.player2.name}',
          style: TextStyle(
              color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 12),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(label, style: TextStyle(color: kTextSecondary, fontSize: 11)),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  final Challenge challenge;
  final bool isMyChallenge;
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final VoidCallback onEnterScore;
  final VoidCallback onVerify;

  const _Actions({
    required this.challenge,
    required this.isMyChallenge,
    required this.onReject,
    required this.onAccept,
    required this.onEnterScore,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    switch (challenge.status) {
      case ChallengeStatus.pending:
        if (isMyChallenge) {
          return Text('Esperando respuesta del rival...',
              style: TextStyle(color: kTextSecondary));
        }
        return Row(
          children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: onReject, child: Text('Rechazar'))),
            const SizedBox(width: 10),
            Expanded(
                child: ElevatedButton(
                    onPressed: onAccept, child: Text('Aceptar'))),
          ],
        );
      case ChallengeStatus.accepted:
        return SizedBox(
            width: double.infinity,
            child: GoldPillButton(
                label: 'REGISTRAR RESULTADO', onPressed: onEnterScore));
      case ChallengeStatus.awaitingVerification:
        if (!isMyChallenge) {
          return SizedBox(
              width: double.infinity,
              child: GoldPillButton(
                  label: 'VERIFICAR RESULTADO', onPressed: onVerify));
        }
        return Text('Esperando verificación del contrincante...',
            style: TextStyle(color: Colors.amber));
      case ChallengeStatus.completed:
        return Text('Reto finalizado y reflejado en la liga ✅',
            style: TextStyle(color: Colors.green));
      case ChallengeStatus.rejected:
        return Text('Reto rechazado',
            style: TextStyle(color: Colors.redAccent));
    }
  }
}

class _NewChallengeSheet extends StatefulWidget {
  final ValueChanged<Pair> onSend;
  const _NewChallengeSheet({required this.onSend});

  @override
  State<_NewChallengeSheet> createState() => _NewChallengeSheetState();
}

class _NewChallengeSheetState extends State<_NewChallengeSheet> {
  Pair? selectedPair;
  late final List<Pair> pairs =
      ligaPesoPesado.pairs.where((p) => p.id != currentUserPair.id).toList();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.9,
      minChildSize: 0.45,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 12),
          Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                  color: kCardBorder, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('Elegir Contrincante',
              style: TextStyle(
                  color: kGold, fontSize: 19, fontWeight: FontWeight.w900)),
          Text('Liga Peso Pesado', style: TextStyle(color: kTextSecondary)),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: pairs.length,
              itemBuilder: (_, i) {
                final pair = pairs[i];
                final selected = selectedPair?.id == pair.id;
                return InkWell(
                  onTap: () =>
                      setState(() => selectedPair = selected ? null : pair),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected ? kTeal.withOpacity(0.12) : kBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                  color: kTeal.withOpacity(0.1),
                                  blurRadius: 12,
                                  spreadRadius: 0)
                            ]
                          : [
                              BoxShadow(
                                  color: kShadowColor.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4))
                            ],
                    ),
                    child: Row(
                      children: [
                        GoldBadge(number: pair.position, size: 24),
                        const SizedBox(width: 10),
                        PairAvatars(
                            url1: pair.player1.avatarUrl,
                            url2: pair.player2.avatarUrl,
                            radius: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${pair.player1.name} & ${pair.player2.name}',
                            style: TextStyle(
                                color: kTextPrimary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text('${pair.wins}W / ${pair.losses}L',
                            style: TextStyle(
                                color: kGold, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: GoldPillButton(
                label: 'ENVIAR RETO',
                icon: Icons.sports_tennis,
                onPressed: selectedPair == null
                    ? null
                    : () => widget.onSend(selectedPair!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
