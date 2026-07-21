import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../widgets/appzeto_animations.dart';
import 'restaurant_detail_screen.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': '🍔'},
    {'name': 'Brunch', 'icon': '🍳'},
    {'name': 'Sea food', 'icon': '🐟'},
    {'name': 'Dessert', 'icon': '🧁'},
    {'name': 'Fast food', 'icon': '🍕'},
    {'name': 'Indian', 'icon': '🍛'},
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    
    // Filter restaurants based on category selection
    final filteredRestaurants = _selectedCategory == 'All'
        ? state.restaurants
        : state.restaurants.where((rest) => rest.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Address Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppTheme.orange, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Home, Jl. Soekarno Hatta 15A...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: AppTheme.orange),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Categories Selector Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Horizontal Category List
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat['name'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat['name'];
                        });
                      },
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 12, bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.orange : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : AppTheme.border,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cat['icon'],
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat['name'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppTheme.textPrimary,
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

              // All Restaurants Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'All restaurants',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Restaurants List
              filteredRestaurants.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          'No restaurants found in this category.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        final rest = filteredRestaurants[index];
                        final isFav = state.favoriteRestaurantIds.contains(rest.id);

                        return BouncingTouchWrapper(
                          onTap: () {
                            Navigator.push(
                              context,
                              AppzetoPageRoute(
                                page: RestaurantDetailScreen(restaurant: rest),
                              ),
                            );
                          },
                          scaleFactor: 0.96,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.border, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Cover photo with Favorite button overlaid
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Image.network(
                                        rest.image,
                                        height: 140,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 12,
                                      top: 12,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white.withOpacity(0.9),
                                        child: IconButton(
                                          icon: Icon(
                                            isFav ? Icons.favorite : Icons.favorite_border,
                                            color: isFav ? AppTheme.orange : AppTheme.textSecondary,
                                          ),
                                          onPressed: () => state.toggleFavoriteRestaurant(rest.id),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // Info panel
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            rest.logo,
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              rest.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.textPrimary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppTheme.orangeLight,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              rest.category,
                                              style: const TextStyle(
                                                color: AppTheme.orange,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: AppTheme.ratingYellow, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${rest.rating}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                          const SizedBox(width: 16),
                                          const Icon(Icons.access_time, color: AppTheme.textSecondary, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            rest.deliveryTime,
                                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                          ),
                                          const SizedBox(width: 16),
                                          const Icon(Icons.delivery_dining, color: AppTheme.textSecondary, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '₹${rest.deliveryFee.toStringAsFixed(2)} delivery',
                                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
