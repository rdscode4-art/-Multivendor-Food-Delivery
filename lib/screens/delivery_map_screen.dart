import 'dart:async';
import 'dart:math';
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
  Timer? _stageTimer;
  int _currentStageIndex = 0;
  final List<Map<String, String>> _deliveryStages = [
    {'title': 'Order Confirmed', 'desc': 'Restaurant has accepted your order.', 'time': '15 min'},
    {'title': 'Preparing Food', 'desc': 'Chef is cooking your delicious meal.', 'time': '12 min'},
    {'title': 'Driver at Restaurant', 'desc': 'Ramesh Kumar is picking up the food.', 'time': '9 min'},
    {'title': 'Out for Delivery', 'desc': 'Ramesh is speeding towards your location.', 'time': '5 min'},
    {'title': 'Arrived', 'desc': 'Ramesh has arrived. Provide OTP to claim!', 'time': '1 min'},
  ];

  final List<String> _chatMessages = [];
  final _chatInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Progress the order stages automatically every 8 seconds
    _stageTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_currentStageIndex < _deliveryStages.length - 1) {
        setState(() {
          _currentStageIndex++;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order Status: ${_deliveryStages[_currentStageIndex]['title']}!'),
            backgroundColor: AppTheme.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        _stageTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stageTimer?.cancel();
    _chatInputController.dispose();
    super.dispose();
  }

  void _showChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.orangeLight,
                    child: const Text('👨', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Ramesh Kumar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('Delivery Partner', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                    ],
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 250,
                child: Column(
                  children: [
                    Expanded(
                      child: _chatMessages.isEmpty
                          ? const Center(
                              child: Text(
                                'No messages yet. Send a note!',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _chatMessages.length,
                              itemBuilder: (context, index) {
                                final msg = _chatMessages[index];
                                final isUser = msg.startsWith('Me:');
                                return Align(
                                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isUser ? AppTheme.orange : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      msg.replaceFirst('Me: ', '').replaceFirst('Driver: ', ''),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isUser ? Colors.white : AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatInputController,
                            decoration: const InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send, color: AppTheme.orange),
                          onPressed: () {
                            final text = _chatInputController.text.trim();
                            if (text.isNotEmpty) {
                              setModalState(() {
                                _chatMessages.add('Me: $text');
                                _chatInputController.clear();
                              });
                              // Simulate automated driver response after 1 second
                              Future.delayed(const Duration(seconds: 1), () {
                                if (!mounted) return;
                                setModalState(() {
                                  _chatMessages.add('Driver: Okay, sure! On my way.');
                                });
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: AppTheme.textSecondary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context, listen: false);
    final stage = _deliveryStages[_currentStageIndex];

    return Scaffold(
      body: Stack(
        children: [
          // Styled Map Canvas background using CustomPainter
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MapPainter(
                    pulseValue: _pulseController.value,
                    progressPercent: (_currentStageIndex + 1) / _deliveryStages.length,
                  ),
                );
              },
            ),
          ),
          
          // Header with back button & share icon
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTheme.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.share, size: 18, color: AppTheme.orange),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delivery live link copied to clipboard!'),
                          backgroundColor: AppTheme.green,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom Tracking Card Overlays
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Live status timeline progress bar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_deliveryStages.length, (index) {
                      final active = index <= _currentStageIndex;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          color: active ? AppTheme.orange : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 10),

                // 2. Main Status Card
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Timer badge
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: (_currentStageIndex + 1) / _deliveryStages.length,
                                  strokeWidth: 4,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.orange),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    stage['time']!.split(' ').first,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.1),
                                  ),
                                  const Text('min', style: TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // Status details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stage['title']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  stage['desc']!,
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          // OTP Badge
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.orangeLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: const [
                                Text('OTP', style: TextStyle(fontSize: 9, color: AppTheme.orange, fontWeight: FontWeight.bold)),
                                Text('8245', style: TextStyle(fontSize: 13, color: AppTheme.orange, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Driver profile detail block
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Text('👨', style: TextStyle(fontSize: 28)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Ramesh Kumar',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Activa 5G • DL 3S AA 1234',
                                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          // Call Button
                          IconButton(
                            icon: const Icon(Icons.phone, color: AppTheme.orange),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calling driver Ramesh Kumar (+91 99999-88888)...'),
                                  backgroundColor: AppTheme.green,
                                ),
                              );
                            },
                          ),
                          // Chat Button
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.orange),
                            onPressed: _showChatDialog,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Exit button: Clear and exit tracking
                ElevatedButton(
                  onPressed: () {
                    state.clearCart();
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
                    'Return to Home',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
  final double progressPercent;

  MapPainter({required this.pulseValue, required this.progressPercent});

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
    paths.add(Path()..moveTo(size.width * 0.25, 0)..lineTo(size.width * 0.25, size.height));
    paths.add(Path()..moveTo(size.width * 0.75, 0)..lineTo(size.width * 0.75, size.height));
    paths.add(Path()..moveTo(0, size.height * 0.2)..lineTo(size.width, size.height * 0.2));
    paths.add(Path()..moveTo(0, size.height * 0.55)..lineTo(size.width, size.height * 0.5));
    paths.add(Path()..moveTo(0, size.height * 0.78)..lineTo(size.width, size.height * 0.78));

    for (var path in paths) {
      canvas.drawPath(path, roadBorderPaint);
      canvas.drawPath(path, roadPaint);
    }

    // Draw route path (delivery route in orange)
    final routePath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.78)
      ..lineTo(size.width * 0.25, size.height * 0.52)
      ..lineTo(size.width * 0.75, size.height * 0.50)
      ..lineTo(size.width * 0.75, size.height * 0.20);

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

    // Marker coordinates
    final startX = size.width * 0.25;
    final startY = size.height * 0.78;
    final endX = size.width * 0.75;
    final endY = size.height * 0.20;

    // Driver moving calculation along paths based on progressPercent
    double driverX, driverY;
    if (progressPercent < 0.33) {
      final subPct = progressPercent / 0.33;
      driverX = startX;
      driverY = startY + (size.height * 0.52 - startY) * subPct;
    } else if (progressPercent < 0.66) {
      final subPct = (progressPercent - 0.33) / 0.33;
      driverX = startX + (size.width * 0.75 - startX) * subPct;
      driverY = size.height * 0.52 + (size.height * 0.50 - size.height * 0.52) * subPct;
    } else {
      final subPct = (progressPercent - 0.66) / 0.34;
      driverX = size.width * 0.75;
      driverY = size.height * 0.50 + (endY - size.height * 0.50) * subPct;
    }

    // Ripple
    final pulsePaint = Paint()
      ..color = AppTheme.orange.withOpacity(1.0 - pulseValue)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(driverX, driverY), 10 + (pulseValue * 20), pulsePaint);

    final driverPinPaint = Paint()..color = AppTheme.orange;
    canvas.drawCircle(Offset(driverX, driverY), 10, driverPinPaint);
    final driverPinInner = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(driverX, driverY), 4, driverPinInner);

    _drawMapPin(canvas, Offset(startX, startY), Colors.green, '🍝');
    _drawMapPin(canvas, Offset(endX, endY), AppTheme.navy, '🏠');
  }

  void _drawMapPin(Canvas canvas, Offset position, Color color, String emoji) {
    final pinPaint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2;

    final path = Path()
      ..moveTo(position.dx, position.dy)
      ..cubicTo(position.dx - 12, position.dy - 12, position.dx - 12, position.dy - 28, position.dx, position.dy - 28)
      ..cubicTo(position.dx + 12, position.dy - 28, position.dx + 12, position.dy - 12, position.dx, position.dy)
      ..close();

    canvas.drawPath(path, pinPaint);
    canvas.drawPath(path, borderPaint);

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
