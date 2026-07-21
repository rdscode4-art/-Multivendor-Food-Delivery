import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Levitating3DAvatar extends StatefulWidget {
  final String photoUrl;
  final double radius;
  final VoidCallback? onTap;

  const Levitating3DAvatar({
    super.key,
    required this.photoUrl,
    this.radius = 48,
    this.onTap,
  });

  @override
  State<Levitating3DAvatar> createState() => _Levitating3DAvatarState();
}

class _Levitating3DAvatarState extends State<Levitating3DAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
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
      animation: _controller,
      builder: (context, child) {
        final floatOffset = _floatAnimation.value;
        final normProgress = (_controller.value - 0.5).abs() * 2; // 0 to 1
        final tiltAngle = math.sin(_controller.value * math.pi * 2) * 0.04;

        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0012)
          ..rotateX(tiltAngle)
          ..rotateY(tiltAngle * 0.8);

        return GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform(
                transform: transform,
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, floatOffset),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppTheme.orange, Color(0xFFFF8C67)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.orange.withValues(
                                alpha: 0.35 + (1 - normProgress) * 0.25,
                              ),
                              blurRadius: 16 + (1 - normProgress) * 12,
                              offset: Offset(0, 8 + floatOffset * 0.5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: widget.radius,
                          backgroundImage: NetworkImage(widget.photoUrl),
                        ),
                      ),

                      // Floating 3D edit badge
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.navy,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                              )
                            ],
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Dynamic 3D ground shadow pulsing in sync with levitation
              AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                width: widget.radius * (1.2 - normProgress * 0.2),
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12 - normProgress * 0.05),
                      blurRadius: 10 + normProgress * 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
