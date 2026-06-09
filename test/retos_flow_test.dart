import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:padel_fighter_league/screens/retos/retos_screen.dart';
import 'package:padel_fighter_league/widgets/common_widgets.dart';

void main() {
  testWidgets('challenge flow opens the opponent selector', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: const RetosScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Enfrentamientos programados'), findsOneWidget);
    expect(find.text('NUEVO RETO'), findsOneWidget);

    await tester.tap(find.text('NUEVO RETO'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Elegir Contrincante'), findsOneWidget);
    expect(find.text('Liga Peso Pesado'), findsWidgets);
    expect(find.text('ENVIAR RETO'), findsOneWidget);
  });

  testWidgets('shared card style remains compact on a narrow screen',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 280,
              child: GoldPillButton(label: 'NUEVO RETO'),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('NUEVO RETO'), findsOneWidget);
  });
}
