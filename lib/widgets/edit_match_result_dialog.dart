import 'package:flutter/material.dart';
import 'common_widgets.dart';
import '../models/models.dart';

void showEditMatchResultDialog(BuildContext context, Match match, VoidCallback onSaved) {
  final s1t1Ctrl = TextEditingController(text: match.set1Team1?.toString() ?? '');
  final s1t2Ctrl = TextEditingController(text: match.set1Team2?.toString() ?? '');
  final s2t1Ctrl = TextEditingController(text: match.set2Team1?.toString() ?? '');
  final s2t2Ctrl = TextEditingController(text: match.set2Team2?.toString() ?? '');
  final s3t1Ctrl = TextEditingController(text: match.set3Team1?.toString() ?? '');
  final s3t2Ctrl = TextEditingController(text: match.set3Team2?.toString() ?? '');

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: kCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Editar Resultado', style: TextStyle(color: kGold, fontWeight: FontWeight.w900)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(match.team1.displayName, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('Set 1', style: TextStyle(color: kTextSecondary))),
                SizedBox(width: 60, child: _ScoreField(controller: s1t1Ctrl)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('-', style: TextStyle(color: kTextSecondary))),
                SizedBox(width: 60, child: _ScoreField(controller: s1t2Ctrl)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Expanded(child: Text('Set 2', style: TextStyle(color: kTextSecondary))),
                SizedBox(width: 60, child: _ScoreField(controller: s2t1Ctrl)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('-', style: TextStyle(color: kTextSecondary))),
                SizedBox(width: 60, child: _ScoreField(controller: s2t2Ctrl)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Expanded(child: Text('Set 3 / TB', style: TextStyle(color: kTextSecondary))),
                SizedBox(width: 60, child: _ScoreField(controller: s3t1Ctrl)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('-', style: TextStyle(color: kTextSecondary))),
                SizedBox(width: 60, child: _ScoreField(controller: s3t2Ctrl)),
              ],
            ),
            const SizedBox(height: 6),
            Text(match.team2.displayName, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: kTextSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            match.set1Team1 = int.tryParse(s1t1Ctrl.text);
            match.set1Team2 = int.tryParse(s1t2Ctrl.text);
            match.set2Team1 = int.tryParse(s2t1Ctrl.text);
            match.set2Team2 = int.tryParse(s2t2Ctrl.text);
            match.set3Team1 = int.tryParse(s3t1Ctrl.text);
            match.set3Team2 = int.tryParse(s3t2Ctrl.text);

            if (match.set1Team1 != null && match.set1Team2 != null) {
              match.status = 'finished';
              final t1Sets = (match.set1Team1! > match.set1Team2! ? 1 : 0) +
                  (match.set2Team1 != null && match.set2Team2 != null && match.set2Team1! > match.set2Team2! ? 1 : 0) +
                  (match.set3Team1 != null && match.set3Team2 != null && match.set3Team1! > match.set3Team2! ? 1 : 0);
              final t2Sets = (match.set1Team2! > match.set1Team1! ? 1 : 0) +
                  (match.set2Team2 != null && match.set2Team1 != null && match.set2Team2! > match.set2Team1! ? 1 : 0) +
                  (match.set3Team2 != null && match.set3Team1 != null && match.set3Team2! > match.set3Team1! ? 1 : 0);
              match.winnerId = t1Sets > t2Sets ? match.team1.id : match.team2.id;

              if (match.winnerId == match.team1.id) {
                match.team1.wins += 1;
                match.team2.losses += 1;
              } else {
                match.team2.wins += 1;
                match.team1.losses += 1;
              }
            }

            Navigator.pop(context);
            onSaved();
          },
          style: ElevatedButton.styleFrom(backgroundColor: kTeal),
          child: const Text('Guardar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

class _ScoreField extends StatelessWidget {
  final TextEditingController controller;
  const _ScoreField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w800),
      decoration: InputDecoration(
        filled: true,
        fillColor: kBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
