import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../screens/address_management_screen.dart';
import 'appzeto_animations.dart';

class AnimatedHomeHeroSection extends StatefulWidget {
  final Function(int) onNavigateToTab;

  const AnimatedHomeHeroSection({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  State<AnimatedHomeHeroSection> createState() => _AnimatedHomeHeroSectionState();
}

class _AnimatedHomeHeroSectionState extends State<AnimatedHomeHeroSection> {
  String _selectedCategory = 'All';
  int _leftImageIndex = 0;
  int _centerImageIndex = 1;
  int _rightImageIndex = 2;
  Timer? _cycleTimer;

  final List<String> _foodImages = [
    'https://images.unsplash.com/photo-1544025162-d76694265947?w=200', // Ribs
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300', // Burger
    'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?w=200', // Kebab
    'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200', // Pizza
    'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=200', // Taco
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200', // Salad
  ];

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'icon': '🍽️'},
    {'name': 'Beverages', 'icon': '🥤'},
    {'name': 'Chicken', 'icon': '🍗'},
    {'name': 'Desserts', 'icon': '🍰'},
    {'name': 'Main Course', 'icon': '🍛'},
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Burgers', 'icon': '🍔'},
  ];

  @override
  void initState() {
    super.initState();
    _cycleTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _leftImageIndex = (_leftImageIndex + 1) % _foodImages.length;
          _centerImageIndex = (_centerImageIndex + 1) % _foodImages.length;
          _rightImageIndex = (_rightImageIndex + 1) % _foodImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    super.dispose();
  }

  void _startVoiceSearch(AppState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const VoiceSearchDialog();
      },
    ).then((recognizedText) {
      if (recognizedText != null && recognizedText is String && recognizedText.isNotEmpty) {
        state.setSearchQuery(recognizedText);
        widget.onNavigateToTab(2); // Redirect to Search Tab
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final user = state.user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Red Header Container with bottom curve
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE21B32), Color(0xFF900B1A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              // Top address and account row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Address Selection
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressManagementScreen(selectMode: false),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 20, color: Colors.white),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        state.selectedAddress?.label ?? 'Select Address',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white70),
                                    ],
                                  ),
                                  Text(
                                    state.selectedAddress?.fullAddress ?? 'Detecting location...',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Actions: Wallet & Profile
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white),
                          onPressed: () => widget.onNavigateToTab(4), // Settings / Account tab
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => widget.onNavigateToTab(4),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(user.photo),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Row + Veg Mode switch
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => widget.onNavigateToTab(2),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Color(0xFFE21B32)),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Search "desserts"',
                                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.mic_none, color: AppTheme.textSecondary),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    _startVoiceSearch(state);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Veg Mode Toggle Switch
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'VEG MODE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 24,
                          width: 44,
                          child: Switch(
                            value: state.isVegMode,
                            activeTrackColor: Colors.green.shade400,
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.grey.shade400,
                            inactiveTrackColor: Colors.white24,
                            onChanged: (val) {
                              state.toggleVegMode(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // "FLAVOUR FEST" Animated Title
              Center(
                child: Text(
                  'FLAVOUR FEST',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFEB3B),
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Translucent Card: Good Food, Great Mood
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('🔱', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Text(
                        'Good Food, Great Mood!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('♨️', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Three Levitating Food Images
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Food Image 1 (Left - Ribs/Steak)
                    LevitatingDishWidget(
                      floatDistance: 8,
                      duration: const Duration(milliseconds: 2200),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        ),
                        child: Container(
                          key: ValueKey<int>(_leftImageIndex),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(
                              image: NetworkImage(_foodImages[_leftImageIndex]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Food Image 2 (Center - Burger) - Larger
                    LevitatingDishWidget(
                      floatDistance: 12,
                      duration: const Duration(milliseconds: 1800),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        ),
                        child: Container(
                          key: ValueKey<int>(_centerImageIndex),
                          width: 95,
                          height: 95,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                            image: DecorationImage(
                              image: NetworkImage(_foodImages[_centerImageIndex]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Food Image 3 (Right - Kebab)
                    LevitatingDishWidget(
                      floatDistance: 7,
                      duration: const Duration(milliseconds: 2500),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        ),
                        child: Container(
                          key: ValueKey<int>(_rightImageIndex),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(
                              image: NetworkImage(_foodImages[_rightImageIndex]),
                              fit: BoxFit.cover,
                            ),
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

        const SizedBox(height: 16),

        // 2. Horizontal Category Pills Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat['name'];
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = cat['name']!);
                  state.selectCategory(cat['name']!);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE21B32) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFE21B32) : AppTheme.border,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        cat['icon']!,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat['name']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class VoiceSearchDialog extends StatefulWidget {
  const VoiceSearchDialog({super.key});

  @override
  State<VoiceSearchDialog> createState() => _VoiceSearchDialogState();
}

class _VoiceSearchDialogState extends State<VoiceSearchDialog> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  String _statusText = 'Listening to your voice...';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _statusText = 'Recognized: "Desserts"';
      });
      _timer = Timer(const Duration(milliseconds: 800), () {
        Navigator.pop(context, 'Desserts');
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Voice Search',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 24),
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mic, color: Color(0xFFE21B32), size: 40),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _statusText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
