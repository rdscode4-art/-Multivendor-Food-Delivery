import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'appzeto_animations.dart';
import 'add_to_cart_components.dart';

class CreativeHorizontalFoodTile extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  const CreativeHorizontalFoodTile({
    super.key,
    required this.foodItem,
    required this.onTap,
    required this.onFavoriteTap,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingTouchWrapper(
      onTap: onTap,
      scaleFactor: 0.96,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circular Levitating Dish Image
            LevitatingDishWidget(
              floatDistance: 4.0,
              duration: const Duration(seconds: 2, milliseconds: 500),
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(foodItem.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    foodItem.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${foodItem.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.orange,
                    ),
                  ),
                ],
              ),
            ),

            // Right Action Column: Favorite & Add To Cart Button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedFavoriteButton(
                  isFavorite: isFavorite,
                  onTap: onFavoriteTap,
                ),
                const SizedBox(height: 8),
                AnimatedAddToCartButton(
                  foodItem: foodItem,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
