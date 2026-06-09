import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'widgets/common_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PadelFighterApp());
}

class PadelFighterApp extends StatelessWidget {
  const PadelFighterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel Fighter League',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBg,
        canvasColor: kBg,
        colorScheme: const ColorScheme.dark(
          primary: kGold,
          secondary: kTeal,
          surface: kCard,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kBg,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: kTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          color: kCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kGold, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: const TextStyle(color: kTextSecondary),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              color: kGold, fontSize: 32, fontWeight: FontWeight.w900),
          headlineMedium: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          titleLarge: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(
              color: kTextSecondary, fontSize: 14, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(
              color: kOnGold, fontSize: 14, fontWeight: FontWeight.w900),
          labelSmall: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 11,
              fontWeight: FontWeight.w600),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: const FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        splashFactory: InkSparkle.splashFactory,
        applyElevationOverlayColor: true,
      ),
      home: const LoginScreen(),
    );
  }
}
