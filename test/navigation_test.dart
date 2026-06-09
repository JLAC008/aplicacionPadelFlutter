import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:padel_fighter_league/screens/main_navigation.dart';
import 'package:padel_fighter_league/screens/ligas/ligas_screen.dart';
import 'package:padel_fighter_league/screens/play/play_hub_screen.dart';
import 'package:padel_fighter_league/screens/ranking/ranking_screen.dart';
import 'package:padel_fighter_league/widgets/common_widgets.dart';

Widget _app(Widget home) {
  return MaterialApp(
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: kBg,
    ),
    home: home,
  );
}

void main() {
  testWidgets('main navigation exposes five primary destinations',
      (tester) async {
    await tester.pumpWidget(_app(const MainNavigation()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Jugar'), findsOneWidget);
    expect(find.text('Ranking'), findsOneWidget);
    expect(find.text('Tienda'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);

    await tester.tap(find.text('Jugar'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Elige cómo quieres jugar'), findsOneWidget);
  });

  testWidgets('play hub links leagues, challenges and bookings',
      (tester) async {
    await tester.pumpWidget(_app(const PlayHubScreen()));
    await tester.pump();

    expect(find.byKey(const Key('play-leagues')), findsOneWidget);
    expect(find.byKey(const Key('play-challenges')), findsOneWidget);
    expect(find.byKey(const Key('play-bookings')), findsOneWidget);

    await tester.tap(find.byKey(const Key('play-leagues')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(LigasScreen), findsOneWidget);
  });

  testWidgets('ranking selector keeps individual and Padel Band flows',
      (tester) async {
    await tester.pumpWidget(_app(const RankingScreen()));
    await tester.pump();

    expect(find.text('Ranking por Pareja'), findsOneWidget);
    expect(find.text('Ranking Individual'), findsOneWidget);
    expect(find.text('Ranking Padel Band'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
