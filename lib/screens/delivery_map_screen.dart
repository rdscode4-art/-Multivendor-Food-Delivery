import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'main_container.dart';

class DeliveryMapScreen extends StatefulWidget {
  final double orderTotal;
  const DeliveryMapScreen({super.key, required this.orderTotal});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          // Styled Map Canvas background using CustomPainter
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MapPainter(pulseValue: _pulseController.value),
                );
              },
            ),
          ),
          
          // Header with back button & overlay title
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTheme.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          
          Positioned(
            top: MediaQuery.of(context).padding.top + 18,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Delivery Map',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: Colors.white, blurRadius: 10),
                  ],
                ),
              ),
            ),
          ),

          // Bottom card overlays
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Driver status card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Radial Progress indicator with time
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 65,
                            height: 65,
                            child: CircularProgressIndicator(
                              value: 0.7,
                              strokeWidth: 5,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.orange),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '12',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textPrimary,
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                'min',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textSecondary,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Order status description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery time',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.cart.isNotEmpty 
                                  ? state.cart.first.foodItem.name 
                                  : 'La Pasta House',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Your order is being processed',
                              style: TextStyle(
                                color: AppTheme.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action button: Hide status
                ElevatedButton(
                  onPressed: () {
                    // Clear cart upon completion of checkout lifecycle
                    state.clearCart();
                    
                    // Return to Home container
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainContainer()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Hide delivery status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final double pulseValue;

  MapPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF1F3F4);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round;

    // Draw stylized grid of roads
    final paths = <Path>[];
    
    // Road 1 (vertical)
    paths.add(Path()..moveTo(size.width * 0.25, 0)..lineTo(size.width * 0.25, size.height));
    // Road 2 (vertical)
    paths.add(Path()..moveTo(size.width * 0.75, 0)..lineTo(size.width * 0.75, size.height));
    // Road 3 (horizontal)
    paths.add(Path()..moveTo(0, size.height * 0.2)..lineTo(size.width, size.height * 0.2));
    // Road 4 (horizontal diagonal)
    paths.add(Path()..moveTo(0, size.height * 0.55)..lineTo(size.width, size.height * 0.5));
    // Road 5 (horizontal bottom)
    paths.add(Path()..moveTo(0, size.height * 0.78)..lineTo(size.width, size.height * 0.78));

    // Paint roads
    for (var path in paths) {
      canvas.drawPath(path, roadBorderPaint);
      canvas.drawPath(path, roadPaint);
    }

    // Draw route path (delivery route in orange)
    final routePath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.78) // Start (Restaurant)
      ..lineTo(size.width * 0.25, size.height * 0.52)
      ..lineTo(size.width * 0.75, size.height * 0.50) // Intersect
      ..lineTo(size.width * 0.75, size.height * 0.20); // End (User Home)

    final routeBorder = Paint()
      ..color = AppTheme.orange.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final routeFill = Paint()
      ..color = AppTheme.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(routePath, routeBorder);
    canvas.drawPath(routePath, routeFill);

    // Draw Restaurant Marker (Start)
    final startX = size.width * 0.25;
    final startY = size.height * 0.78;
    
    // Draw User Marker (End)
    final endX = size.width * 0.75;
    final endY = size.height * 0.20;

    // Draw Pulse ripple at driver location (moving along the route)
    // Driver is roughly 60% of the way along the route
    final driverX = size.width * 0.50;
    final driverY = size.height * 0.51;

    final pulsePaint = Paint()
      ..color = AppTheme.orange.withOpacity(1.0 - pulseValue)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(driverX, driverY), 10 + (pulseValue * 20), pulsePaint);

    // Driver pin circle
    final driverPinPaint = Paint()..color = AppTheme.orange;
    canvas.drawCircle(Offset(driverX, driverY), 10, driverPinPaint);
    final driverPinInner = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(driverX, driverY), 4, driverPinInner);

    // Draw pins
    _drawMapPin(canvas, Offset(startX, startY), Colors.green, '🍝');
    _drawMapPin(canvas, Offset(endX, endY), AppTheme.navy, '🏠');
  }

  void _drawMapPin(Canvas canvas, Offset position, Color color, String emoji) {
    final pinPaint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2;

    // Draw teardrop pin shape
    final path = Path()
      ..moveTo(position.dx, position.dy)
      ..cubicTo(position.dx - 12, position.dy - 12, position.dx - 12, position.dy - 28, position.dx, position.dy - 28)
      ..cubicTo(position.dx + 12, position.dy - 28, position.dx + 12, position.dy - 12, position.dx, position.dy)
      ..close();

    canvas.drawPath(path, pinPaint);
    canvas.drawPath(path, borderPaint);

    // Draw text emoji inside/above
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: const TextStyle(fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(position.dx - (textPainter.width / 2), position.dy - 23),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
