import 'package:flutter/material.dart';

/// Custom Appzeto-style Page Route with smooth scale, slide, and fade transitions
class AppzetoPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  AppzetoPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
              reverseCurve: Curves.easeInCubic,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.06, 0.08),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
                  child: child,
                ),
              ),
            );
          },
        );
}

/// Appzeto Bouncing Touch Wrapper for interactive feedback on tap
class BouncingTouchWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleFactor;

  const BouncingTouchWrapper({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleFactor = 0.95,
  });

  @override
  State<BouncingTouchWrapper> createState() => _BouncingTouchWrapperState();
}

class _BouncingTouchWrapperState extends State<BouncingTouchWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Appzeto Levitating Floating Dish Effect
class LevitatingDishWidget extends StatefulWidget {
  final Widget child;
  final double floatDistance;
  final Duration duration;

  const LevitatingDishWidget({
    super.key,
    required this.child,
    this.floatDistance = 6.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<LevitatingDishWidget> createState() => _LevitatingDishWidgetState();
}

class _LevitatingDishWidgetState extends State<LevitatingDishWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -widget.floatDistance / 2, end: widget.floatDistance / 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
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
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Appzeto Pulsing Heart Favorite Icon Widget
class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const AnimatedFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.isFavorite ? const Color(0xFFFF5252) : const Color(0xFF94A3B8),
            size: 18,
          ),
        ),
      ),
    );
  }
}
