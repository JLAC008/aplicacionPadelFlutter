import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

const Color kGold = Color(0xFFD8B85A);
const Color kTeal = Color(0xFF21CDBD);
const Color kGoldDark = Color(0xFFAA8532);
const Color kOnGold = Color(0xFF0A0E1A);
const Color kBg = Color(0xFF0D0E0F);
const Color kCard = Color(0xFF202122);
const Color kCardBorder = Color(0xFF343638);
const Color kTextSecondary = Color(0xFFA6A7AA);
const Color kTextPrimary = Colors.white;
const Color kActiveCard = Color(0xFF292A2C);
const Color kShadowColor = Color(0xFF000000);

const String kCourtImage = 'assets/images/generated/court-night.png';
const String kHeroPlayerImage = 'assets/images/generated/hero-player.png';
const String kShopImage = 'assets/images/generated/shop-campaign.png';
const String kProductsImage = 'assets/images/generated/shop-products.png';

class AppColors {
  static Color get gold => kGold;
  static Color get teal => kTeal;
  static Color get bg => kBg;
  static Color get card => kCard;
  static Color get border => kCardBorder;
  static Color get textSecondary => kTextSecondary;
  static Color get textPrimary => kTextPrimary;
}

class NeonScaffold extends StatelessWidget {
  final Widget child;
  const NeonScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF111214), kBg, Color(0xFF08090A)],
        ),
      ),
      child: child,
    );
  }
}

BoxDecoration elegantCard({
  bool active = false,
  double radius = 20,
  Color? color,
}) {
  return BoxDecoration(
    color: color ?? (active ? kActiveCard : kCard),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: active ? kGold.withValues(alpha: 0.65) : kCardBorder,
      width: active ? 1.2 : 0.8,
    ),
    boxShadow: [
      BoxShadow(
        color: kShadowColor.withValues(alpha: 0.24),
        blurRadius: 12,
        offset: const Offset(0, 5),
      ),
    ],
  );
}

class AppContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const AppContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.maxWidth = 720,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class LocalOrNetworkImage extends StatelessWidget {
  final String source;
  final BoxFit fit;
  final Widget? fallback;

  const LocalOrNetworkImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        fit: fit,
        errorBuilder: (_, __, ___) => fallback ?? _fallback(),
      );
    }
    return CachedNetworkImage(
      imageUrl: source,
      fit: fit,
      errorWidget: (_, __, ___) => fallback ?? _fallback(),
      placeholder: (_, __) => Container(color: kCardBorder),
    );
  }

  Widget _fallback() => Container(
        color: kCard,
        child: const Icon(Icons.sports_tennis, color: kGold, size: 42),
      );
}

// Kept for backward compatibility during migration
BoxDecoration neonCardDecoration({
  Color borderColor = kCardBorder,
  bool active = false,
  double radius = 12,
}) {
  return elegantCard(active: active, radius: radius);
}

class GoldBadge extends StatelessWidget {
  final int number;
  final double size;
  const GoldBadge({super.key, required this.number, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8C84A), Color(0xFFB8941E)],
        ),
        boxShadow: [
          BoxShadow(
              color: kGold.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            color: const Color(0xFF0A0E1A),
            fontWeight: FontWeight.bold,
            fontSize: size * 0.45,
          ),
        ),
      ),
    );
  }
}

class PairAvatars extends StatelessWidget {
  final String url1;
  final String url2;
  final double radius;
  const PairAvatars(
      {super.key, required this.url1, required this.url2, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 3.2,
      height: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            child: _avatar(url2, radius),
          ),
          Positioned(
            left: radius * 1.2,
            child: _avatar(url1, radius),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String url, double r) {
    return Container(
      width: r * 2 + 3,
      height: r * 2 + 3,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kGold, kTeal],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
              color: kCardBorder,
              child: Icon(Icons.person, color: kTextSecondary),
            ),
            placeholder: (_, __) => Container(color: kCardBorder),
          ),
        ),
      ),
    );
  }
}

class SingleAvatar extends StatelessWidget {
  final String url;
  final double radius;
  final Widget? badge;
  const SingleAvatar(
      {super.key, required this.url, this.radius = 28, this.badge});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: radius * 2 + 3,
          height: radius * 2 + 3,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kGold, kTeal],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: kCardBorder,
                  child: Icon(Icons.person, color: kTextSecondary),
                ),
                placeholder: (_, __) => Container(color: kCardBorder),
              ),
            ),
          ),
        ),
        if (badge != null)
          Positioned(
            bottom: -4,
            left: -4,
            child: badge!,
          ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: kGold,
            ),
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: kCardBorder.withOpacity(0.3),
      height: 1,
      thickness: 1,
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class PadelHeader extends StatelessWidget {
  final String title;
  final double height;
  final bool compact;
  const PadelHeader({
    super.key,
    required this.title,
    this.height = 210,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: height,
      pinned: true,
      backgroundColor: kBg,
      title: Text(title),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            LocalOrNetworkImage(
              source: compact ? kCourtImage : kHeroPlayerImage,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    kBg.withOpacity(0.82),
                    kBg,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppTitleBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  const AppTitleBar({
    super.key,
    this.title = 'Padel Fighter League',
    this.showBack = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final trailing = actions != null
        ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
        : const SizedBox(width: 48);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 8, 8),
        child: Row(
          children: [
            if (showBack)
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: kTeal),
              )
            else
              const SizedBox(width: 48),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kGold,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class HeroImagePanel extends StatelessWidget {
  final double height;
  final String imageUrl;
  final BoxFit imageFit;
  const HeroImagePanel({
    super.key,
    this.height = 190,
    this.imageUrl = kHeroPlayerImage,
    this.imageFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGold.withOpacity(0.72), width: 2),
        boxShadow: [BoxShadow(color: kTeal.withOpacity(0.16), blurRadius: 20)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LocalOrNetworkImage(
            source: imageUrl,
            fit: imageFit,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.08),
                  Colors.black.withOpacity(0.58)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionShortcutBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  const SectionShortcutBar(
      {super.key, required this.selectedIndex, required this.onSelected});

  static const _items = [
    (Icons.emoji_events, 'LIGAS'),
    (Icons.sports_tennis, 'RETOS'),
    (Icons.leaderboard, 'RANKING'),
    (Icons.person, 'PERFIL'),
    (Icons.shopping_bag, 'TIENDA'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_items.length, (index) {
        final selected = index == selectedIndex;
        final item = _items[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == _items.length - 1 ? 0 : 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onSelected(index),
              child: Container(
                height: 76,
                decoration: elegantCard(
                  active: selected,
                  radius: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.$1, color: selected ? kOnGold : kGold, size: 27),
                    const SizedBox(height: 7),
                    FittedBox(
                      child: Text(
                        item.$2,
                        style: TextStyle(
                          color: selected ? kOnGold : kTeal,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class PadelBandBadge extends StatelessWidget {
  final double score;
  final double width;
  const PadelBandBadge({super.key, required this.score, this.width = 62});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFEBD36A), Color(0xFFB8941E)]),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE98A), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PADEL BAND',
            style: TextStyle(
                color: kOnGold, fontSize: 7, fontWeight: FontWeight.w900),
          ),
          Text(
            score.toStringAsFixed(2),
            style: TextStyle(
                color: kOnGold, fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const Icon(Icons.arrow_upward, color: Color(0xFF1DD878), size: 14),
        ],
      ),
    );
  }
}

class GoldPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const GoldPillButton(
      {super.key, required this.label, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: kGold,
        foregroundColor: kOnGold,
        disabledBackgroundColor: kCardBorder,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle:
            const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.2),
      ),
    );
  }
}

String pairName(dynamic pair) {
  if (pair.teamName != null && pair.teamName!.isNotEmpty) {
    return '${pair.player1.name} & ${pair.player2.name}';
  }
  return '${pair.player1.name} & ${pair.player2.name}';
}

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  const ShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kCard,
      highlightColor: kCardBorder,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class PadelFadeInList extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final Duration itemDelay;
  final Duration itemDuration;
  final Curve curve;

  const PadelFadeInList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemDelay = const Duration(milliseconds: 80),
    this.itemDuration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return itemBuilder(index)
            .animate()
            .fadeIn(
              duration: itemDuration,
              delay: itemDelay * index,
              curve: curve,
            )
            .slideX(
              begin: 0.15,
              end: 0,
              duration: itemDuration,
              delay: itemDelay * index,
              curve: curve,
            );
      }),
    );
  }
}

class AnimatedCountText extends StatefulWidget {
  final double value;
  final TextStyle? style;
  final int decimals;
  final Duration duration;
  const AnimatedCountText({
    super.key,
    required this.value,
    this.style,
    this.decimals = 0,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedCountText> createState() => _AnimatedCountTextState();
}

class _AnimatedCountTextState extends State<AnimatedCountText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCountText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.reset();
      _animation = Tween<double>(begin: 0, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.decimals == 0
              ? '${_animation.value.toInt()}'
              : _animation.value.toStringAsFixed(widget.decimals),
          style: widget.style,
        );
      },
    );
  }
}
