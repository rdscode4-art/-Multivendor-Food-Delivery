import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'restaurant_detail_screen.dart';
import 'food_detail_screen.dart';
import 'cart_screen.dart';
import '../widgets/interactive_3d_banner.dart';
import '../widgets/animated_home_hero.dart';
import '../widgets/creative_food_card.dart';
import '../widgets/creative_horizontal_tile.dart';
import '../widgets/appzeto_animations.dart';
import '../widgets/add_to_cart_components.dart';

class DiscoverScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;
  const DiscoverScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              // Creative Animated Hero Section (Greeting, Location, 3D Hero Box, Category Pills)
              AnimatedHomeHeroSection(onNavigateToTab: onNavigateToTab),
              const SizedBox(height: 12),
              _buildFilterChipsRow(context, state),
              const SizedBox(height: 10),

              // Featured Dishes Section (Creative 3D Pop-out Bowl Cards as requested)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Dishes 🌟',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onNavigateToTab(2),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Horizontal Pop-out Dish Cards Carousel
              SizedBox(
                height: 275,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  itemCount: state.foodItems.length,
                  itemBuilder: (context, index) {
                    final food = state.foodItems[index];
                    final isFav = state.favoriteFoodIds.contains(food.id);

                    return CreativeFoodCard(
                      foodItem: food,
                      isFavorite: isFav,
                      onFavoriteTap: () => state.toggleFavoriteFood(food.id),
                      onTap: () {
                        Navigator.push(
                          context,
                          AppzetoPageRoute(
                            page: FoodDetailScreen(foodItem: food),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Promo Discount Card (Dynamic sliding PageView)
              PromoBannerSlider(onNavigateToTab: onNavigateToTab),
              const SizedBox(height: 24),

              // Fastest Delivery Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fastest delivery ⚡',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onNavigateToTab(1),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Horizontal Restaurants list
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  itemCount: state.restaurants.length,
                  itemBuilder: (context, index) {
                    final rest = state.restaurants[index];
                    return BouncingTouchWrapper(
                      onTap: () {
                        Navigator.push(
                          context,
                          AppzetoPageRoute(
                            page: RestaurantDetailScreen(restaurant: rest),
                          ),
                        );
                      },
                      scaleFactor: 0.95,
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.border, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Cover Image
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.network(
                                  rest.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            
                            // Info
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        rest.logo,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          rest.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: AppTheme.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: AppTheme.ratingYellow, size: 14),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${rest.rating}',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.access_time, color: AppTheme.textSecondary, size: 14),
                                      const SizedBox(width: 2),
                                      Text(
                                        rest.deliveryTime,
                                        style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Popular Items Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular items 🔥',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onNavigateToTab(2),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Popular Foods list using CreativeHorizontalFoodTile
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: state.foodItems.length > 4 ? 4 : state.foodItems.length,
                itemBuilder: (context, index) {
                  final food = state.foodItems[index];
                  final isFav = state.favoriteFoodIds.contains(food.id);

                  return CreativeHorizontalFoodTile(
                    foodItem: food,
                    isFavorite: isFav,
                    onFavoriteTap: () => state.toggleFavoriteFood(food.id),
                    onTap: () {
                      Navigator.push(
                        context,
                        AppzetoPageRoute(
                          page: FoodDetailScreen(foodItem: food),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Cuisine-Based Sections
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Browse Cuisines 🍕',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  children: [
                    _buildCuisineCard('Italian 🍝', const Color(0xFFE8F5E9), 'Pasta'),
                    _buildCuisineCard('Indian 🍛', const Color(0xFFFFF3E0), 'Indian'),
                    _buildCuisineCard('Mexican 🌮', const Color(0xFFFFEBEE), 'Fast food'),
                    _buildCuisineCard('Japanese 🍣', const Color(0xFFE0F7FA), 'Sea food'),
                    _buildCuisineCard('Desserts 🍰', const Color(0xFFFCE4EC), 'Dessert'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Offers & Discounts Vouchers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Offers & Discounts 🎁',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  children: [
                    _buildVoucherCard('WELCOME50', 'Get ₹50 Off', 'On your first order', const Color(0xFFFF9E79)),
                    _buildVoucherCard('FREEDEL', 'Free Delivery', 'No delivery charges', const Color(0xFF4CD964)),
                    _buildVoucherCard('SUPER100', '₹100 Cashback', 'On orders above ₹500', const Color(0xFF1DA1F2)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sponsored & New Restaurants Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Sponsored & New Restaurants ✨',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  itemCount: state.restaurants.length > 3 ? 3 : state.restaurants.length,
                  itemBuilder: (context, index) {
                    final rest = state.restaurants[index];
                    final isNew = index % 2 == 0;
                    return BouncingTouchWrapper(
                      onTap: () {
                        Navigator.push(
                          context,
                          AppzetoPageRoute(page: RestaurantDetailScreen(restaurant: rest)),
                        );
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 12, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Image.network(rest.image, fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isNew ? AppTheme.orange : AppTheme.navy,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        isNew ? 'NEW' : 'SPONSORED',
                                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(rest.logo),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      rest.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.star, color: AppTheme.ratingYellow, size: 12),
                                  const SizedBox(width: 2),
                                  Text('${rest.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Recently Ordered Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Recently Ordered 🍕',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  itemCount: state.foodItems.length > 3 ? 3 : state.foodItems.length,
                  itemBuilder: (context, index) {
                    final food = state.foodItems[index];
                    return Container(
                      width: 260,
                      margin: const EdgeInsets.only(right: 12, bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(food.image, width: 48, height: 48, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  food.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${food.price}',
                                  style: const TextStyle(color: AppTheme.orange, fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              state.addOrIncrementCartItem(food);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Re-ordered ${food.name}!'),
                                  backgroundColor: AppTheme.green,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.orange,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Re-order', style: TextStyle(fontSize: 10, color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        const AnimatedFloatingCartBar(),
      ],
    ),
  ),
);
  }

  Widget _buildCuisineCard(String title, Color bgColor, String category) {
    return Builder(
      builder: (context) {
        final state = AppStateProvider.of(context, listen: false);
        return GestureDetector(
          onTap: () {
            state.selectCategory(category);
            onNavigateToTab(1); // Go to Restaurants tab
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary),
            ),
          ),
        );
      }
    );
  }

  Widget _buildVoucherCard(String code, String discount, String subtitle, Color bgColor) {
    return Builder(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    discount,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  code,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildFilterChipsRow(BuildContext context, AppState state) {
    final under30Active = state.maxDeliveryTimeFilter == 30;
    final under45Active = state.maxDeliveryTimeFilter == 45;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          // FILTERS
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Select Delivery Filter',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          title: const Text('Under 30 mins delivery'),
                          trailing: state.maxDeliveryTimeFilter == 30 ? const Icon(Icons.check, color: AppTheme.orange) : null,
                          onTap: () {
                            state.setMaxDeliveryTimeFilter(30);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Under 45 mins delivery'),
                          trailing: state.maxDeliveryTimeFilter == 45 ? const Icon(Icons.check, color: AppTheme.orange) : null,
                          onTap: () {
                            state.setMaxDeliveryTimeFilter(45);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Clear Filters'),
                          onTap: () {
                            state.setMaxDeliveryTimeFilter(null);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border, width: 1.5),
              ),
              child: Row(
                children: const [
                  Icon(Icons.tune, size: 16, color: AppTheme.textPrimary),
                  SizedBox(width: 4),
                  Text(
                    'FILTERS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),
          ),

          // Under 30 mins
          GestureDetector(
            onTap: () {
              if (under30Active) {
                state.setMaxDeliveryTimeFilter(null);
              } else {
                state.setMaxDeliveryTimeFilter(30);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: under30Active ? AppTheme.orangeLight : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: under30Active ? AppTheme.orange : AppTheme.border,
                  width: 1.5,
                ),
              ),
              child: Text(
                'Under 30 mins',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: under30Active ? FontWeight.bold : FontWeight.w600,
                  color: under30Active ? AppTheme.orange : AppTheme.textPrimary,
                ),
              ),
            ),
          ),

          // Under 45 mins
          GestureDetector(
            onTap: () {
              if (under45Active) {
                state.setMaxDeliveryTimeFilter(null);
              } else {
                state.setMaxDeliveryTimeFilter(45);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: under45Active ? AppTheme.orangeLight : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: under45Active ? AppTheme.orange : AppTheme.border,
                  width: 1.5,
                ),
              ),
              child: Text(
                'Under 45 mins',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: under45Active ? FontWeight.bold : FontWeight.w600,
                  color: under45Active ? AppTheme.orange : AppTheme.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromoBannerSlider extends StatefulWidget {
  final Function(int) onNavigateToTab;

  const PromoBannerSlider({super.key, required this.onNavigateToTab});

  @override
  State<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<PromoBannerSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  double _pageOffset = 0.0;
  Timer? _autoPlayTimer;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Get your 30% daily\ndiscount now!',
      'buttonText': 'Order now',
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
      'color': AppTheme.orange,
    },
    {
      'title': 'Free Delivery on\nyour first order!',
      'buttonText': 'Claim now',
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200',
      'color': AppTheme.navy,
    },
    {
      'title': 'Try our new spicy\nIndian cuisines!',
      'buttonText': 'Explore menu',
      'image': 'https://images.unsplash.com/photo-1585938338392-50a59970d8ee?w=200',
      'color': const Color(0xFF2D6A4F),
    },
    {
      'title': 'Sweeten your day\nwith 20% off dessert!',
      'buttonText': 'Order sweets',
      'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=200',
      'color': const Color(0xFF8F2D56),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _pageOffset = _pageController.page!;
        });
      }
    });

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentIndex + 1) % _slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 154,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              final offset = index - _pageOffset;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Interactive3DBanner(
                  slide: slide,
                  onNavigateToTab: widget.onNavigateToTab,
                  pageOffset: offset,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        
        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            final isActive = _currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 16 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.orange : AppTheme.textMuted,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
