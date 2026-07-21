import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/payment_methods_screen.dart';

class Interactive3DCard extends StatefulWidget {
  final PaymentMethodItem card;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const Interactive3DCard({
    super.key,
    required this.card,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  State<Interactive3DCard> createState() => _Interactive3DCardState();
}

class _Interactive3DCardState extends State<Interactive3DCard>
    with SingleTickerProviderStateMixin {
  // Flip Animation Controller
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  // Touch Tilt Offsets
  double _rotX = 0.0;
  double _rotY = 0.0;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    setState(() {
      // Calculate normalized tilt angles based on drag displacement
      _rotX -= details.delta.dy * 0.005;
      _rotY += details.delta.dx * 0.005;

      // Clamp tilt range for realistic 3D feel
      _rotX = _rotX.clamp(-0.35, 0.35);
      _rotY = _rotY.clamp(-0.35, 0.35);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // Smoothly spring back tilt angle to 0
    setState(() {
      _rotX = 0.0;
      _rotY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.card.gradientColors ?? [AppTheme.navy, const Color(0xFF2C3E50)];

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            widget.onSetDefault();
            _toggleFlip();
          },
          onPanUpdate: (details) => _onPanUpdate(details, constraints.biggest),
          onPanEnd: _onPanEnd,
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final flipValue = _flipAnimation.value;
              final isBackVisible = flipValue >= math.pi / 2;

              // Compute 3D Transformation Matrix
              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.0015) // Perspective distortion
                ..rotateX(_rotX)
                ..rotateY(_rotY + flipValue);

              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withValues(alpha: 0.45),
                        blurRadius: 20 + (_rotX.abs() + _rotY.abs()) * 20,
                        offset: Offset(_rotY * 15, 8 + _rotX * 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        // Holographic 3D Specular Light Sheen Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.15),
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.05),
                                ],
                                begin: Alignment(_rotY * 2 - 1, _rotX * 2 - 1),
                                end: Alignment(_rotY * 2 + 1, _rotX * 2 + 1),
                              ),
                            ),
                          ),
                        ),

                        // Render Front or Back depending on flip rotation angle
                        isBackVisible
                            ? Transform(
                                transform: Matrix4.identity()..rotateY(math.pi),
                                alignment: Alignment.center,
                                child: _buildCardBack(),
                              )
                            : _buildCardFront(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // --- CARD FRONT VIEW ---
  Widget _buildCardFront() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Gold EMV Chip Graphic
                  Container(
                    width: 38,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFE066), Color(0xFFD4AF37)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 14,
                          top: 0,
                          bottom: 0,
                          child: Container(width: 1, color: Colors.black26),
                        ),
                        Positioned(
                          top: 12,
                          left: 0,
                          right: 0,
                          child: Container(height: 1, color: Colors.black26),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.contactless, color: Colors.white70, size: 24),
                ],
              ),

              Row(
                children: [
                  if (widget.card.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.orange,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: const Text(
                        'DEFAULT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 20),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ],
          ),

          // Card Number
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CARD NUMBER',
                style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.2),
              ),
              const SizedBox(height: 4),
              Text(
                widget.card.details,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
              ),
            ],
          ),

          // Footer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD HOLDER',
                    style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.card.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'EXPIRES',
                    style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.2),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '12/28',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Visa / Mastercard Network Badge
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xCCEB001B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xCCF79E1B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CARD BACK VIEW ---
  Widget _buildCardBack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        // Black Magnetic Strip
        Container(
          height: 44,
          color: Colors.black,
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AUTHORIZED SIGNATURE / NOT VALID UNLESS SIGNED',
                style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 0.8),
              ),
              const SizedBox(height: 6),

              // Signature Bar with CVV Code Box
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.87),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.card.name,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontFamily: 'serif',
                              color: AppTheme.navy,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // CVV Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.orange, width: 1.5),
                    ),
                    child: const Text(
                      '892',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppTheme.navy,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                'Issued by Foodies Pay Services. Tap card to flip back to front view.',
                style: TextStyle(color: Colors.white54, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
