import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../services/api_service.dart';
import 'appzeto_animations.dart';
import '../screens/cart_screen.dart';

/// Animated Morphing "Add to Cart" / Quantity Controller Widget for Food Cards
class AnimatedAddToCartButton extends StatefulWidget {
  final FoodItem foodItem;
  final double height;

  const AnimatedAddToCartButton({
    super.key,
    required this.foodItem,
    this.height = 36.0,
  });

  @override
  State<AnimatedAddToCartButton> createState() => _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerPulse() {
    _controller.forward(from: 0.0);
  }

  Future<void> _handleAdd(AppState state) async {
    _triggerPulse();
    state.addOrIncrementCartItem(widget.foodItem);

    // Call API in background
    try {
      await ApiService.instance.addToCart(
        menuItemId: widget.foodItem.id,
        quantity: 1,
        restaurantId: widget.foodItem.restaurantId,
      );
    } catch (e) {
      // API error handled gracefully in terminal logs
    }
  }

  Future<void> _handleDecrement(AppState state) async {
    _triggerPulse();
    state.decrementCartItem(widget.foodItem);

    // Call API in background
    try {
      await ApiService.instance.updateCartQuantity(
        menuItemId: widget.foodItem.id,
        quantity: state.getItemQuantity(widget.foodItem.id),
      );
    } catch (e) {
      // Ignore background errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final quantity = state.getItemQuantity(widget.foodItem.id);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: quantity == 0
            ? Material(
                key: const ValueKey('add_btn'),
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleAdd(state),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.orange, Color(0xFFFF7D42)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.orange.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'ADD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                key: const ValueKey('counter_btn'),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.navy,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.navy.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _handleDecrement(state),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.remove_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _handleAdd(state),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.orange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Appzeto Floating Bottom Animated Cart Bar Widget
class AnimatedFloatingCartBar extends StatelessWidget {
  const AnimatedFloatingCartBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final totalItems = state.cart.fold<int>(0, (sum, item) => sum + item.quantity);

    if (totalItems == 0) return const SizedBox.shrink();

    return Positioned(
      left: 16,
      right: 16,
      bottom: 20,
      child: BouncingTouchWrapper(
        onTap: () {
          Navigator.push(
            context,
            AppzetoPageRoute(page: const CartScreen()),
          );
        },
        scaleFactor: 0.96,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // Cart Icon Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.orange.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppTheme.orange,
                      size: 22,
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppTheme.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Item count & Total Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$totalItems ${totalItems == 1 ? "Item" : "Items"} in Cart',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${state.cartTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              // View Cart Action Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.orange,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.orange.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Text(
                      'View Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
