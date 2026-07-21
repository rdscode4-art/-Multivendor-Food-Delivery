import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation controller for both bouncing and waving
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Bouncing up and down (bobbing)
    _bounceAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Waving hand rotation (in radians: -0.2 to 0.3)
    _waveAnimation = Tween<double>(begin: -0.2, end: 0.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _controller.repeat(reverse: true);

    // Transition to welcome screen after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.orange,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background patterns
            Positioned(
              top: -100,
              right: -100,
              child: CircleAvatar(
                radius: 150,
                backgroundColor: Colors.white.withOpacity(0.05),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: CircleAvatar(
                radius: 120,
                backgroundColor: Colors.white.withOpacity(0.05),
              ),
            ),
            
            // Welcoming mascot and title
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Mascot Character Container
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _bounceAnimation.value),
                        child: CustomPaint(
                          size: const Size(200, 240),
                          painter: MascotPainter(
                            waveAngle: _waveAnimation.value,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  
                  // Text banner
                  const Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Foodies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Spinner or load bar
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3.5,
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MascotPainter extends CustomPainter {
  final double waveAngle;

  MascotPainter({required this.waveAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.55);
    final mascotWidth = size.width * 0.65;
    final mascotHeight = size.height * 0.45;

    // Paints
    final bunPaint = Paint()..color = const Color(0xFFF5A623)..style = PaintingStyle.fill;
    final pattyPaint = Paint()..color = const Color(0xFF8B572A)..style = PaintingStyle.fill;
    final lettucePaint = Paint()..color = const Color(0xFF7ED321)..style = PaintingStyle.fill;
    final cheesePaint = Paint()..color = const Color(0xFFF8E71C)..style = PaintingStyle.fill;
    final blackPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    final whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final tonguePaint = Paint()..color = const Color(0xFFFF5E5B)..style = PaintingStyle.fill;
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.12)..style = PaintingStyle.fill;

    // 1. Draw mascot floor shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.95),
        width: mascotWidth * 1.1,
        height: 12,
      ),
      shadowPaint,
    );

    // 2. Draw Chef Hat (Top decoration)
    final hatPath = Path();
    final hatBaseY = center.dy - mascotHeight / 2 - 5;
    hatPath.moveTo(center.dx - 24, hatBaseY);
    hatPath.lineTo(center.dx + 24, hatBaseY);
    hatPath.lineTo(center.dx + 20, hatBaseY - 12);
    hatPath.lineTo(center.dx - 20, hatBaseY - 12);
    hatPath.close();
    canvas.drawPath(hatPath, whitePaint);

    final hatTopPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 18, hatBaseY - 24), 16, hatTopPaint);
    canvas.drawCircle(Offset(center.dx + 18, hatBaseY - 24), 16, hatTopPaint);
    canvas.drawCircle(Offset(center.dx, hatBaseY - 32), 20, hatTopPaint);

    // Hat band outline
    final outlinePaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(center.dx - 20, hatBaseY), Offset(center.dx + 20, hatBaseY), outlinePaint);
    canvas.drawLine(Offset(center.dx - 18, hatBaseY - 12), Offset(center.dx + 18, hatBaseY - 12), outlinePaint);

    // 3. Draw Legs & Feet
    final legPaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    
    // Left Leg
    canvas.drawLine(
      Offset(center.dx - 20, center.dy + mascotHeight / 2 - 5),
      Offset(center.dx - 25, size.height * 0.92),
      legPaint,
    );
    // Right Leg
    canvas.drawLine(
      Offset(center.dx + 20, center.dy + mascotHeight / 2 - 5),
      Offset(center.dx + 25, size.height * 0.92),
      legPaint,
    );

    // Feet (Little red shoes)
    final shoePaint = Paint()..color = const Color(0xFFFF5E5B)..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(center.dx - 36, size.height * 0.90, center.dx - 16, size.height * 0.95),
        const Radius.circular(6),
      ),
      shoePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(center.dx + 16, size.height * 0.90, center.dx + 36, size.height * 0.95),
        const Radius.circular(6),
      ),
      shoePaint,
    );

    // 4. Draw Burger Body
    // Lower Bun
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(center.dx - mascotWidth / 2, center.dy + 8, center.dx + mascotWidth / 2, center.dy + mascotHeight / 2),
        const Radius.circular(16),
      ),
      bunPaint,
    );

    // Patty
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(center.dx - mascotWidth / 2 - 4, center.dy - 6, center.dx + mascotWidth / 2 + 4, center.dy + 12),
        const Radius.circular(10),
      ),
      pattyPaint,
    );

    // Cheese layer (hanging corners)
    final cheesePath = Path();
    cheesePath.moveTo(center.dx - mascotWidth / 2 + 8, center.dy + 4);
    cheesePath.lineTo(center.dx - mascotWidth / 4, center.dy + 16);
    cheesePath.lineTo(center.dx, center.dy + 4);
    cheesePath.lineTo(center.dx + mascotWidth / 3, center.dy + 18);
    cheesePath.lineTo(center.dx + mascotWidth / 2 - 8, center.dy + 4);
    cheesePath.close();
    canvas.drawPath(cheesePath, cheesePaint);

    // Lettuce (wavy green line)
    final lettucePath = Path();
    lettucePath.moveTo(center.dx - mascotWidth / 2 - 6, center.dy - 10);
    for (double i = -mascotWidth / 2 - 6; i <= mascotWidth / 2 + 6; i += 12) {
      lettucePath.quadraticBezierTo(
        center.dx + i + 6,
        center.dy - 18,
        center.dx + i + 12,
        center.dy - 10,
      );
    }
    canvas.drawPath(lettucePath, lettucePaint);

    // Upper Bun (Top dome)
    final upperBunRect = Rect.fromLTRB(
      center.dx - mascotWidth / 2,
      center.dy - mascotHeight / 2,
      center.dx + mascotWidth / 2,
      center.dy - 6,
    );
    canvas.drawArc(upperBunRect, math.pi, math.pi, true, bunPaint);

    // 5. Draw Cute Face Elements (On Upper Bun)
    final faceY = center.dy - mascotHeight / 4 - 2;
    
    // Left Eye
    canvas.drawCircle(Offset(center.dx - 18, faceY), 7, blackPaint);
    canvas.drawCircle(Offset(center.dx - 20, faceY - 2), 2.5, whitePaint); // shine
    
    // Right Eye
    canvas.drawCircle(Offset(center.dx + 18, faceY), 7, blackPaint);
    canvas.drawCircle(Offset(center.dx + 16, faceY - 2), 2.5, whitePaint); // shine

    // Happy smiling open mouth
    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, faceY + 10),
      width: 22,
      height: 14,
    );
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - 11, faceY + 8);
    mouthPath.quadraticBezierTo(center.dx, faceY + 10, center.dx + 11, faceY + 8);
    mouthPath.arcTo(mouthRect, 0, math.pi, false);
    mouthPath.close();
    
    canvas.drawPath(mouthPath, blackPaint);
    
    // Tongue
    canvas.save();
    canvas.clipPath(mouthPath);
    canvas.drawCircle(Offset(center.dx, faceY + 16), 7, tonguePaint);
    canvas.restore();

    // Rosy Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFF5E5B).withOpacity(0.4)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 28, faceY + 6), 5, cheekPaint);
    canvas.drawCircle(Offset(center.dx + 28, faceY + 6), 5, cheekPaint);

    // 6. Draw Left Arm (Static resting arm)
    final armPaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;
    
    final leftArmPath = Path();
    leftArmPath.moveTo(center.dx - mascotWidth / 2 + 2, center.dy + 4);
    leftArmPath.quadraticBezierTo(
      center.dx - mascotWidth / 2 - 12,
      center.dy + 15,
      center.dx - mascotWidth / 2 - 6,
      center.dy + 25,
    );
    canvas.drawPath(leftArmPath, armPaint);
    // Draw left hand glove
    canvas.drawCircle(Offset(center.dx - mascotWidth / 2 - 6, center.dy + 25), 6, whitePaint);
    canvas.drawCircle(Offset(center.dx - mascotWidth / 2 - 6, center.dy + 25), 6, outlinePaint);

    // 7. Draw Right Arm (Waving hand - Animating!)
    canvas.save();
    // Shoulder pivot point for right arm
    final shoulderX = center.dx + mascotWidth / 2 - 2;
    final shoulderY = center.dy - 2;
    canvas.translate(shoulderX, shoulderY);
    canvas.rotate(waveAngle);

    final rightArmPath = Path();
    rightArmPath.moveTo(0, 0);
    // Arm extended upwards/outwards
    rightArmPath.quadraticBezierTo(
      15,
      -15,
      12,
      -35,
    );
    canvas.drawPath(rightArmPath, armPaint);

    // Waving hand glove
    final handCenter = Offset(12, -35);
    canvas.drawCircle(handCenter, 8, whitePaint);
    canvas.drawCircle(handCenter, 8, outlinePaint);
    
    // Draw little fingers waving
    final fingerPaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(handCenter + const Offset(-4, -6), handCenter + const Offset(-4, -12), fingerPaint);
    canvas.drawLine(handCenter + const Offset(0, -7), handCenter + const Offset(0, -14), fingerPaint);
    canvas.drawLine(handCenter + const Offset(4, -6), handCenter + const Offset(4, -12), fingerPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MascotPainter oldDelegate) {
    return oldDelegate.waveAngle != waveAngle;
  }
}
