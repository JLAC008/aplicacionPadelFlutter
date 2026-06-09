import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';

class LigaDetailScreen extends StatefulWidget {
  final Liga liga;
  const LigaDetailScreen({super.key, required this.liga});

  @override
  State<LigaDetailScreen> createState() => _LigaDetailScreenState();
}

class _LigaDetailScreenState extends State<LigaDetailScreen> {
  late Liga liga;

  @override
  void initState() {
    super.initState();
    liga = widget.liga;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: kBg,
      body: NeonScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTitleBar(showBack: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
              child: Text(
                liga.name,
                style: textTheme.headlineSmall?.copyWith(
                  color: kTextPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                child: PadelFadeInList(
                  itemCount: liga.pairs.length,
                  itemBuilder: (index) {
                    final pair = liga.pairs[index];
                    final isCurrentChallenger =
                        index == liga.currentChallengerIndex;
                    final hasVerifiedChallenge =
                        pair.hasCompletedChallenge ||
                            mockChallenges.any((c) =>
                                c.ligaId == liga.id &&
                                c.status == ChallengeStatus.completed &&
                                (c.challenger.id == pair.id ||
                                    c.challenged.id == pair.id));
                    return _PairRow(
                      pair: pair,
                      position: index + 1,
                      isCurrentChallenger: isCurrentChallenger,
                      hasVerifiedChallenge: hasVerifiedChallenge,
                      onChallenge: () => _showChallengeDialog(pair, index),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GoldPillButton(
        onPressed: _showNewChallengeDialog,
        icon: Icons.sports_tennis,
        label: 'NUEVO RETO',
      ),
    );
  }

  void _showChallengeDialog(Pair challengedPair, int challengedIndex) {
    final challengerIndex = liga.currentChallengerIndex;
    final challengerPair = liga.pairs[challengerIndex];

    if (challengedIndex == challengerIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No puedes retarte a ti mismo'),
            backgroundColor: Colors.red),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ChallengeBottomSheet(
        challenger: challengerPair,
        challenged: challengedPair,
        onConfirm: () {
          Navigator.pop(context);
          _sendChallenge(challengerPair, challengedPair);
        },
      ),
    );
  }

  void _sendChallenge(Pair challenger, Pair challenged) {
    final newChallenge = Challenge(
      id: 'ch_${DateTime.now().millisecondsSinceEpoch}',
      challenger: challenger,
      challenged: challenged,
      ligaId: liga.id,
      ligaName: liga.name,
      status: ChallengeStatus.pending,
      proposedDate: 'Por acordar',
    );
    mockChallenges.add(newChallenge);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Reto enviado a ${challenged.player1.name} & ${challenged.player2.name}'),
        backgroundColor: kTeal,
      ),
    );
  }

  void _showNewChallengeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _LigaChallengeSheet(
        pairs: liga.pairs
            .where((p) => p.id != liga.pairs[liga.currentChallengerIndex].id)
            .toList(),
        currentChallengerIndex: liga.currentChallengerIndex,
        onSend: (challenged) {
          final challenger = liga.pairs[liga.currentChallengerIndex];
          final newChallenge = Challenge(
            id: 'ch_${DateTime.now().millisecondsSinceEpoch}',
            challenger: challenger,
            challenged: challenged,
            ligaId: liga.id,
            ligaName: liga.name,
            status: ChallengeStatus.pending,
            proposedDate: 'Por acordar',
          );
          mockChallenges.add(newChallenge);
          setState(() {});
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

class _PairRow extends StatelessWidget {
  final Pair pair;
  final int position;
  final bool isCurrentChallenger;
  final bool hasVerifiedChallenge;
  final VoidCallback onChallenge;

  const _PairRow({
    required this.pair,
    required this.position,
    required this.isCurrentChallenger,
    required this.hasVerifiedChallenge,
    required this.onChallenge,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final total = pair.wins + pair.losses;
    final progress = total > 0 ? pair.wins / total : 0.0;

    return GestureDetector(
      onTap: onChallenge,
      child: Container(
        height: 64,
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: elegantCard(
          radius: 16,
          color: isCurrentChallenger ? kActiveCard : null,
        ),
        child: Row(
          children: [
            GoldBadge(number: position, size: 24),
            const SizedBox(width: 7),
            PairAvatars(
              url1: pair.player1.avatarUrl,
              url2: pair.player2.avatarUrl,
              radius: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${pair.player1.name} & ${pair.player2.name}',
                          style: textTheme.titleMedium?.copyWith(
                            color: kTextPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasVerifiedChallenge)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.check_circle,
                              color: Colors.green, size: 16),
                        ),
                    ],
                  ),
                  if (pair.teamName != null)
                    Text(pair.teamName!,
                        style: textTheme.bodySmall?.copyWith(
                            color: kTextSecondary))
                  else if (isCurrentChallenger)
                    Text('Turno de retar',
                        style: textTheme.bodySmall?.copyWith(
                            color: kTeal, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 34,
                  height: 34,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: kCardBorder,
                        valueColor: const AlwaysStoppedAnimation(kGold),
                      ),
                      Text(
                        '${pair.wins}W',
                        style: textTheme.labelSmall?.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                if (isCurrentChallenger)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: kGold,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('RETAR',
                        style: textTheme.labelSmall?.copyWith(
                            color: kOnGold, fontWeight: FontWeight.w900))
                  )
                else
                  const Icon(Icons.chevron_right, color: kTextSecondary, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeBottomSheet extends StatelessWidget {
  final Pair challenger;
  final Pair challenged;
  final VoidCallback onConfirm;

  const _ChallengeBottomSheet({
    required this.challenger,
    required this.challenged,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: kCardBorder, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text('Enviar Reto',
              style: textTheme.titleLarge?.copyWith(
                  color: kGold, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _PairChip(pair: challenger, label: 'Retador')),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('VS',
                    style: TextStyle(
                        color: kGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
              Expanded(child: _PairChip(pair: challenged, label: 'Retado')),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'El reto deberá ser aceptado por el contrincante. Una vez jugado, el resultado necesitará verificación.',
            style: textTheme.bodySmall?.copyWith(color: kTextSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: kTeal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Enviar Reto',
                  style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _PairChip extends StatelessWidget {
  final Pair pair;
  final String label;
  const _PairChip({required this.pair, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label,
              style: textTheme.labelSmall?.copyWith(color: kTextSecondary)),
          const SizedBox(height: 8),
          PairAvatars(
              url1: pair.player1.avatarUrl,
              url2: pair.player2.avatarUrl,
              radius: 18),
          const SizedBox(height: 8),
          Text(
            '${pair.player1.name} & ${pair.player2.name}',
            style: textTheme.bodySmall?.copyWith(
                color: kTextPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LigaChallengeSheet extends StatefulWidget {
  final List<Pair> pairs;
  final int currentChallengerIndex;
  final Function(Pair) onSend;

  const _LigaChallengeSheet({
    required this.pairs,
    required this.currentChallengerIndex,
    required this.onSend,
  });

  @override
  State<_LigaChallengeSheet> createState() => _LigaChallengeSheetState();
}

class _LigaChallengeSheetState extends State<_LigaChallengeSheet> {
  Pair? _selectedPair;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      minChildSize: 0.4,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: kCardBorder, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('Elegir Contrincante',
              style: textTheme.titleLarge?.copyWith(
                  color: kGold, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.pairs.length,
              itemBuilder: (_, i) {
                final pair = widget.pairs[i];
                final isSelected = _selectedPair?.id == pair.id;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedPair = isSelected ? null : pair),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? kTeal.withValues(alpha: 0.1) : kBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [BoxShadow(color: kTeal.withValues(alpha: 0.08), blurRadius: 16, spreadRadius: 0)]
                          : [BoxShadow(color: kShadowColor.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))],
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
                            style: textTheme.bodyMedium?.copyWith(
                                color: kTextPrimary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text('${pair.wins}W/${pair.losses}L',
                            style: textTheme.labelSmall
                                ?.copyWith(color: kGold)),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.check_circle,
                              color: kTeal, size: 20),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _selectedPair != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kCard,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: kGold.withValues(alpha: 0.08), blurRadius: 20, spreadRadius: 0),
                              ],
                            ),
                          child: Row(
                            children: [
                              PairAvatars(
                                  url1: _selectedPair!.player1.avatarUrl,
                                  url2: _selectedPair!.player2.avatarUrl,
                                  radius: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${_selectedPair!.player1.name} & ${_selectedPair!.player2.name}',
                                  style: textTheme.bodyMedium?.copyWith(
                                      color: kTextPrimary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                '${_selectedPair!.wins}W/${_selectedPair!.losses}L',
                                style: textTheme.labelSmall
                                    ?.copyWith(color: kGold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => widget.onSend(_selectedPair!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kTeal,
                              disabledBackgroundColor: kCardBorder,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Enviar Reto',
                                style: textTheme.titleMedium?.copyWith(
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Selecciona un contrincante',
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
