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
            ],
          ),
        ),
        const AnimatedFloatingCartBar(),
      ],
    ),
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
