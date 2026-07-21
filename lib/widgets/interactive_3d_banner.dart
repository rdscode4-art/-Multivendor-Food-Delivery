import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Interactive3DBanner extends StatefulWidget {
  final Map<String, dynamic> slide;
  final Function(int) onNavigateToTab;
  final double pageOffset;

  const Interactive3DBanner({
    super.key,
    required this.slide,
    required this.onNavigateToTab,
    required this.pageOffset,
  });

  @override
  State<Interactive3DBanner> createState() => _Interactive3DBannerState();
}

class _Interactive3DBannerState extends State<Interactive3DBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Touch Tilt values
  double _tiltX = 0.0;
  double _tiltY = 0.0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _tiltX -= details.delta.dy * 0.006;
      _tiltY += details.delta.dx * 0.006;

      _tiltX = _tiltX.clamp(-0.25, 0.25);
      _tiltY = _tiltY.clamp(-0.25, 0.25);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _tiltX = 0.0;
      _tiltY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final slideColor = widget.slide['color'] as Color;

    // Combine PageView scroll offset with touch tilt for 3D effect
    final pageRotateY = widget.pageOffset * -0.35;
    final scaleFactor = (1 - (widget.pageOffset.abs() * 0.15)).clamp(0.85, 1.0);

    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0012)
      ..rotateX(_tiltX)
      ..rotateY(_tiltY + pageRotateY)
      ..scale(scaleFactor, scaleFactor, 1.0);

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          final floatVal = _floatAnimation.value;

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: slideColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: slideColor.withValues(alpha: 0.45),
                    blurRadius: 16 + (_tiltX.abs() + _tiltY.abs()) * 15,
                    offset: Offset(_tiltY * 12, 8 + _tiltX * 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Background 3D Specular Light sheen
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.18),
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.08),
                            ],
                            begin: Alignment(_tiltY * 2 - 1, _tiltX * 2 - 1),
                            end: Alignment(_tiltY * 2 + 1, _tiltX * 2 + 1),
                          ),
                        ),
                      ),
                    ),

                    // Decorative 3D Ring Circle
                    Positioned(
                      right: -30,
                      bottom: -30,
                      child: Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Banner Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.slide['title'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),

                                ElevatedButton(
                                  onPressed: () {
                                    widget.onNavigateToTab(1); // Restaurants tab
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: slideColor == AppTheme.navy
                                        ? AppTheme.orange
                                        : AppTheme.navy,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.slide['buttonText'] as String,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.arrow_forward_rounded, size: 14),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Floating 3D Food Circle Image with Levitating Motion
                          Transform.translate(
                            offset: Offset(0, floatVal),
                            child: Container(
                              width: 95,
                              height: 95,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  width: 3.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 14 + floatVal.abs() * 2,
                                    offset: Offset(0, 6 + floatVal * 0.5),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(widget.slide['image'] as String),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
