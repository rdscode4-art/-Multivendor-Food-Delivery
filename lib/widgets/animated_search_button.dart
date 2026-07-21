import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'appzeto_animations.dart';

/// Animated Dynamic Rotating Search Placeholder Text Widget (Swiggy/Zomato/Appzeto style)
class AnimatedRotatingSearchPlaceholder extends StatefulWidget {
  final List<String> items;
  final Duration interval;
  final TextStyle? style;

  const AnimatedRotatingSearchPlaceholder({
    super.key,
    this.items = const [
      'Search "Pizza"...',
      'Search "Paneer Pulao"...',
      'Search "Butter Chicken"...',
      'Search "Aloo Tikki Burger"...',
      'Search "Pesto Pasta"...',
      'Search "Shrimp Pizza"...',
      'Search "Chocolate Cake"...',
      'Search "Tandoori Chicken"...',
      'Search "Cold Coffee"...',
    ],
    this.interval = const Duration(milliseconds: 2500),
    this.style,
  });

  @override
  State<AnimatedRotatingSearchPlaceholder> createState() =>
      _AnimatedRotatingSearchPlaceholderState();
}

class _AnimatedRotatingSearchPlaceholderState
    extends State<AnimatedRotatingSearchPlaceholder> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRotation();
  }

  void _startRotation() {
    _timer = Timer.periodic(widget.interval, (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.items.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.7),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Text(
        widget.items[_currentIndex],
        key: ValueKey<int>(_currentIndex),
        style: widget.style ??
            const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Appzeto-style Animated Search Action Button with Pulse & Bounce
class AnimatedSearchButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;

  const AnimatedSearchButton({
    super.key,
    required this.onTap,
    this.label = 'SEARCH',
  });

  @override
  State<AnimatedSearchButton> createState() => _AnimatedSearchButtonState();
}

class _AnimatedSearchButtonState extends State<AnimatedSearchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
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
    return ScaleTransition(
      scale: _pulseAnim,
      child: BouncingTouchWrapper(
        onTap: widget.onTap,
        scaleFactor: 0.92,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.orange, Color(0xFFFF7D42)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.orange.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Appzeto Animated Home Hero Search Bar Widget with Rotating Placeholder Text
class AnimatedHomeHeroSearchBar extends StatefulWidget {
  final VoidCallback onTap;

  const AnimatedHomeHeroSearchBar({
    super.key,
    required this.onTap,
  });

  @override
  State<AnimatedHomeHeroSearchBar> createState() => _AnimatedHomeHeroSearchBarState();
}

class _AnimatedHomeHeroSearchBarState extends State<AnimatedHomeHeroSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.04, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return BouncingTouchWrapper(
          onTap: widget.onTap,
          scaleFactor: 0.97,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.orange.withValues(alpha: _glowAnimation.value),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppTheme.orange.withValues(alpha: _glowAnimation.value * 2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.orange.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search_rounded, color: AppTheme.orange, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: AnimatedRotatingSearchPlaceholder(),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.orange,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.orange.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.tune_rounded, color: Colors.white, size: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
