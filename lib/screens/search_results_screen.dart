import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../widgets/appzeto_animations.dart';
import '../widgets/animated_search_button.dart';
import 'food_detail_screen.dart';
import 'restaurant_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final VoidCallback onBackToFilter;
  const SearchResultsScreen({super.key, required this.onBackToFilter});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sort and Filter States
  String _sortBy = 'Recommended';
  String _vegFilter = 'All'; // All, Veg, Non-Veg
  bool _freeDelivery = false;
  bool _hasOffers = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Sort Dropdown button
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: Colors.white,
              dividerColor: AppTheme.border,
            ),
            child: PopupMenuButton<String>(
              initialValue: _sortBy,
              onSelected: (val) => setState(() => _sortBy = val),
              itemBuilder: (context) => [
                'Recommended',
                'Rating',
                'Price Low to High',
                'Price High to Low',
              ].map((val) => PopupMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 13)))).toList(),
              child: Chip(
                backgroundColor: _sortBy != 'Recommended' ? AppTheme.orangeLight : Colors.white,
                side: BorderSide(color: _sortBy != 'Recommended' ? AppTheme.orange : AppTheme.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sort, size: 14, color: _sortBy != 'Recommended' ? AppTheme.orange : AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(_sortBy, style: TextStyle(fontSize: 12, color: _sortBy != 'Recommended' ? AppTheme.orange : AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Veg/Non-veg Chip
          ChoiceChip(
            label: Text(_vegFilter == 'All' ? 'Veg/Non-Veg' : _vegFilter),
            selected: _vegFilter != 'All',
            selectedColor: AppTheme.orangeLight,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            labelStyle: TextStyle(
              fontSize: 12,
              color: _vegFilter != 'All' ? AppTheme.orange : AppTheme.textPrimary,
              fontWeight: _vegFilter != 'All' ? FontWeight.bold : FontWeight.normal,
            ),
            side: BorderSide(color: _vegFilter != 'All' ? AppTheme.orange : AppTheme.border),
            onSelected: (selected) {
              setState(() {
                if (_vegFilter == 'All') {
                  _vegFilter = 'Veg';
                } else if (_vegFilter == 'Veg') {
                  _vegFilter = 'Non-Veg';
                } else {
                  _vegFilter = 'All';
                }
              });
            },
            showCheckmark: false,
          ),
          const SizedBox(width: 8),

          // Free Delivery Chip
          FilterChip(
            label: const Text('Free Delivery'),
            selected: _freeDelivery,
            selectedColor: AppTheme.orangeLight,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            labelStyle: TextStyle(
              fontSize: 12,
              color: _freeDelivery ? AppTheme.orange : AppTheme.textPrimary,
              fontWeight: _freeDelivery ? FontWeight.bold : FontWeight.normal,
            ),
            side: BorderSide(color: _freeDelivery ? AppTheme.orange : AppTheme.border),
            onSelected: (val) => setState(() => _freeDelivery = val),
            showCheckmark: false,
          ),
          const SizedBox(width: 8),

          // Offers Chip
          FilterChip(
            label: const Text('Offers'),
            selected: _hasOffers,
            selectedColor: AppTheme.orangeLight,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            labelStyle: TextStyle(
              fontSize: 12,
              color: _hasOffers ? AppTheme.orange : AppTheme.textPrimary,
              fontWeight: _hasOffers ? FontWeight.bold : FontWeight.normal,
            ),
            side: BorderSide(color: _hasOffers ? AppTheme.orange : AppTheme.border),
            onSelected: (val) => setState(() => _hasOffers = val),
            showCheckmark: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final query = state.searchQuery.toLowerCase();

    // Filter food items
    final filteredFoods = state.foodItems.where((food) {
      final matchesName = food.name.toLowerCase().contains(query);
      final matchesTag = food.tags.any((t) => t.toLowerCase() == query);
      final matchesCategory = food.category.toLowerCase().contains(query);
      bool matchesSearch = matchesName || matchesTag || matchesCategory;

      if (!matchesSearch) return false;

      // Veg Filter
      if (_vegFilter == 'Veg') {
        final isVeg = food.tags.any((t) => t.toLowerCase() == 'vegetarian' || t.toLowerCase() == 'veg');
        if (!isVeg) return false;
      } else if (_vegFilter == 'Non-Veg') {
        final isVeg = food.tags.any((t) => t.toLowerCase() == 'vegetarian' || t.toLowerCase() == 'veg');
        if (isVeg) return false;
      }

      return true;
    }).toList();

    // Sort food items
    if (_sortBy == 'Price Low to High') {
      filteredFoods.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price High to Low') {
      filteredFoods.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Rating') {
      filteredFoods.sort((a, b) => b.rating.compareTo(a.rating));
    }

    // Filter restaurants
    final filteredRestaurants = state.restaurants.where((rest) {
      final matchesName = rest.name.toLowerCase().contains(query);
      final matchesCategory = rest.category.toLowerCase().contains(query);
      bool matchesSearch = matchesName || matchesCategory;

      if (!matchesSearch) return false;

      if (_freeDelivery && rest.deliveryFee > 0) {
        return false;
      }

      if (_hasOffers) {
        // Mock that restaurants r1, r2, r5 have offers
        if (rest.id != 'r1' && rest.id != 'r2' && rest.id != 'r5') return false;
      }

      return true;
    }).toList();

    // Sort restaurants
    if (_sortBy == 'Rating') {
      filteredRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header search box with Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  BouncingTouchWrapper(
                    onTap: widget.onBackToFilter,
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BouncingTouchWrapper(
                      onTap: widget.onBackToFilter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              state.searchQuery,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.clear, color: AppTheme.textSecondary, size: 16),
                              onPressed: widget.onBackToFilter,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Filter & Sort Bar
            _buildFilterBar(),
            const SizedBox(height: 8),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppTheme.orange,
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                tabs: const [
                  Tab(text: 'Food items'),
                  Tab(text: 'Restaurants'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab contents
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Food items View
                  filteredFoods.isEmpty
                      ? const Center(
                          child: Text(
                            'No food items match your search.',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredFoods.length,
                          itemBuilder: (context, index) {
                            final food = filteredFoods[index];
                            final isFav = state.favoriteFoodIds.contains(food.id);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoodDetailScreen(foodItem: food),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
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
                                    // Food Image with favorite overlay
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                          child: Image.network(
                                            food.image,
                                            height: 160,
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
                                              onPressed: () => state.toggleFavoriteFood(food.id),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    // Details panel
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            food.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            food.description,
                                            style: const TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Text(
                                                '₹${food.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.orange,
                                                ),
                                              ),
                                              const Spacer(),
                                              const Icon(Icons.star, color: AppTheme.ratingYellow, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${food.rating}',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(width: 16),
                                              const Icon(Icons.access_time, color: AppTheme.textSecondary, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                food.deliveryTime,
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

                  // Restaurants View
                  filteredRestaurants.isEmpty
                      ? const Center(
                          child: Text(
                            'No restaurants match your search.',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredRestaurants.length,
                          itemBuilder: (context, index) {
                            final rest = filteredRestaurants[index];
                            final isFav = state.favoriteRestaurantIds.contains(rest.id);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantDetailScreen(restaurant: rest),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppTheme.border, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
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
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Text(rest.logo, style: const TextStyle(fontSize: 20)),
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
                                          const Icon(Icons.star, color: AppTheme.ratingYellow, size: 16),
                                          const SizedBox(width: 4),
                                          Text('${rest.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
