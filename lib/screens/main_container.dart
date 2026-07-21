import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'discover_screen.dart';
import 'restaurants_screen.dart';
import 'search_filter_screen.dart';
import 'search_results_screen.dart';
import 'profile_screen.dart';

class MainContainer extends StatefulWidget {
  final int initialTab;
  const MainContainer({super.key, this.initialTab = 0});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  late int _currentIndex;
  
  // Custom navigation state inside the Search tab to switch between tag filter and search results
  bool _showingSearchResults = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 2) {
        // Reset search view when entering the Search tab
        _showingSearchResults = false;
      }
    });
  }

  void triggerSearch() {
    setState(() {
      _showingSearchResults = true;
    });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return DiscoverScreen(onNavigateToTab: changeTab);
      case 1:
        return const RestaurantsScreen();
      case 2:
        return _showingSearchResults
            ? SearchResultsScreen(onBackToFilter: () {
                setState(() => _showingSearchResults = false);
              })
            : SearchFilterScreen(onSearchTriggered: triggerSearch);
      case 3:
        return const FavoritesScreen();
      case 4:
        return const ProfileScreen();
      default:
        return DiscoverScreen(onNavigateToTab: changeTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.explore_outlined, Icons.explore, 'Discover'),
                _buildNavItem(1, Icons.storefront_outlined, Icons.storefront, 'Restaurants'),
                _buildNavItem(2, Icons.search, Icons.search, 'Search'),
                _buildNavItem(3, Icons.favorite_border, Icons.favorite, 'Favorite'),
                _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppTheme.orange : AppTheme.textSecondary;
    final icon = isSelected ? filledIcon : outlineIcon;

    return GestureDetector(
      onTap: () => changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Simple Favorites Screen placeholder to showcase the starred items in a functional way
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final favFoods = state.foodItems.where((food) => state.favoriteFoodIds.contains(food.id)).toList();
    final favRestaurants = state.restaurants.where((rest) => state.favoriteRestaurantIds.contains(rest.id)).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (favRestaurants.isNotEmpty) ...[
                const Text(
                  'Favorite Restaurants',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: favRestaurants.length,
                  itemBuilder: (context, index) {
                    final rest = favRestaurants[index];
                    return Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppTheme.border, width: 1),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(rest.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(rest.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.star, color: AppTheme.ratingYellow, size: 16),
                            const SizedBox(width: 4),
                            Text('${rest.rating}'),
                            const SizedBox(width: 12),
                            const Icon(Icons.access_time, color: AppTheme.textSecondary, size: 16),
                            const SizedBox(width: 4),
                            Text(rest.deliveryTime),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: AppTheme.orange),
                          onPressed: () => state.toggleFavoriteRestaurant(rest.id),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
              
              if (favFoods.isNotEmpty) ...[
                const Text(
                  'Favorite Foods',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: favFoods.length,
                  itemBuilder: (context, index) {
                    final food = favFoods[index];
                    return Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppTheme.border, width: 1),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(food.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('₹${food.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: AppTheme.orange),
                          onPressed: () => state.toggleFavoriteFood(food.id),
                        ),
                      ),
                    );
                  },
                ),
              ],

              if (favRestaurants.isEmpty && favFoods.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80.0),
                    child: Column(
                      children: [
                        Icon(Icons.favorite_border, color: AppTheme.textMuted, size: 64),
                        const SizedBox(height: 16),
                        const Text(
                          'No favorites added yet!',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
