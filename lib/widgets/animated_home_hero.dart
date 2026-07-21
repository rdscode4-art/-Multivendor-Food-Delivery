import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../screens/cart_screen.dart';
import 'animated_search_button.dart';

class AnimatedHomeHeroSection extends StatefulWidget {
  final Function(int) onNavigateToTab;

  const AnimatedHomeHeroSection({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  State<AnimatedHomeHeroSection> createState() => _AnimatedHomeHeroSectionState();
}

class _AnimatedHomeHeroSectionState extends State<AnimatedHomeHeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;
  String _selectedCategory = 'All';

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'icon': '🍽️'},
    {'name': 'Burgers', 'icon': '🍔'},
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Indian', 'icon': '🍛'},
    {'name': 'Pasta', 'icon': '🍝'},
    {'name': 'Dessert', 'icon': '🍰'},
    {'name': 'Drinks', 'icon': '🥤'},
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final user = state.user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Top Header Row: User Avatar, Greeting & Location, Cart Icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Levitating User Avatar
              AnimatedBuilder(
                animation: _floatAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnim.value * 0.5),
                    child: GestureDetector(
                      onTap: () => widget.onNavigateToTab(4), // Navigate to profile
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppTheme.orange, Color(0xFFFF8C67)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.orange.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(user.photo),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),

              // Greeting & Location Selector
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getGreeting()}, ${user.name.split(' ').first}!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: const [
                        Icon(Icons.location_on, size: 14, color: AppTheme.orange),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '742 Evergreen Terrace, Springfield',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, size: 16, color: AppTheme.textSecondary),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Cart Button with Animated Badge
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: AppTheme.navy, size: 22),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                  ),
                  if (state.cart.isNotEmpty)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppTheme.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${state.cart.fold<int>(0, (sum, item) => sum + item.quantity)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 2. Creative Hero Banner Box with Floating Elements
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedBuilder(
            animation: _floatAnim,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E202C), Color(0xFF2D3246)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.navy.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Promo Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.orange.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.orange.withValues(alpha: 0.6)),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.bolt, color: AppTheme.orange, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'CRAVING DELICIOUS FOOD?',
                                style: TextStyle(
                                  color: AppTheme.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Floating 3D Special Cashback Pill
                        Transform.translate(
                          offset: Offset(0, _floatAnim.value * 0.8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CD964),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: const Text(
                              '🔥 50% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Order Food Online\nFast & Fresh to Door! 🍕',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Interactive Animated Search Bar inside Hero Box
                    AnimatedHomeHeroSearchBar(
                      onTap: () => widget.onNavigateToTab(2), // Navigate to Search Tab
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // 3. Category Filter Chips Carousel
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat['name'];
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = cat['name']!);
                  if (cat['name'] != 'All') {
                    state.selectCategory(cat['name']!);
                  } else {
                    state.selectCategory('All');
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.orange : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppTheme.orange : AppTheme.border,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.orange.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
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
