import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'appzeto_animations.dart';
import 'add_to_cart_components.dart';

class CreativeFoodCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  const CreativeFoodCard({
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
        width: 195,
        margin: const EdgeInsets.only(top: 40, bottom: 25, right: 16, left: 4),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // 1. White Base Card with Soft Shadow
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 75,
                left: 16,
                right: 16,
                bottom: 28,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    foodItem.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Subtitle / Category
                  Text(
                    foodItem.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Text(
                    '₹${foodItem.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.orange,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Levitating Pop-out Overhanging Dish Image
            Positioned(
              top: -38,
              child: LevitatingDishWidget(
                floatDistance: 8.0,
                duration: const Duration(seconds: 3),
                child: Hero(
                  tag: 'food_image_${foodItem.id}',
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(foodItem.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Top-Right Animated Favorite Heart Button
            Positioned(
              top: -5,
              right: 12,
              child: AnimatedFavoriteButton(
                isFavorite: isFavorite,
                onTap: onFavoriteTap,
              ),
            ),

            // 4. Overlapping Bottom Add To Cart Button
            Positioned(
              bottom: -16,
              child: AnimatedAddToCartButton(
                foodItem: foodItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
