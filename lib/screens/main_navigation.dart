import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'home/home_screen.dart';
import 'play/play_hub_screen.dart';
import 'ranking/ranking_screen.dart';
import 'tienda/tienda_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PlayHubScreen(),
    RankingScreen(),
    TiendaScreen(),
    ProfileScreen(),
  ];

  void switchToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _FloatingGlassBar(
        currentIndex: _currentIndex,
        onTap: switchToTab,
      ),
    );
  }
}

class _FloatingGlassBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingGlassBar({
    required this.currentIndex,
    required this.onTap,
  });

  static const _tabs = [
    (Icons.home_outlined, Icons.home, 'Inicio'),
    (Icons.sports_tennis_outlined, Icons.sports_tennis, 'Jugar'),
    (Icons.leaderboard_outlined, Icons.leaderboard, 'Ranking'),
    (Icons.shopping_bag_outlined, Icons.shopping_bag, 'Tienda'),
    (Icons.person_outline, Icons.person, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: kBg.withOpacity(0.88),
            boxShadow: [
              BoxShadow(
                color: kShadowColor.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / _tabs.length;
              const pillWidth = 36.0;
              final pillLeft =
                  currentIndex * tabWidth + (tabWidth - pillWidth) / 2;

              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    left: pillLeft,
                    top: 5,
                    child: Container(
                      width: pillWidth,
                      height: 3,
                      decoration: BoxDecoration(
                        color: kGold,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: kGold.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(_tabs.length, (index) {
                      final isActive = index == currentIndex;
                      final tab = _tabs[index];

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onTap(index),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                scale: isActive ? 1.15 : 1.0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOutBack,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: isActive
                                      ? BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  kGold.withValues(alpha: 0.25),
                                              blurRadius: 12,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        )
                                      : null,
                                  child: Icon(
                                    isActive ? tab.$2 : tab.$1,
                                    color: isActive ? kGold : kTextSecondary,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isActive ? 1.0 : 0.0,
                                child: Text(
                                  tab.$3,
                                  style: const TextStyle(
                                    color: kGold,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
