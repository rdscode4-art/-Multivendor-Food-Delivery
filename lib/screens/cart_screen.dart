import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'delivery_map_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final cart = state.cart;

    // Filter recommended foods that aren't already in the cart
    final recItems = state.foodItems.where((food) {
      return !cart.any((cartItem) => cartItem.foodItem.id == food.id) &&
          (food.category == 'Dessert' || food.category == 'Drinks');
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Your order'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cart.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 80, color: AppTheme.textMuted),
                    const SizedBox(height: 16),
                    const Text(
                      'Your order is empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add delicious meals from your favorite restaurants to begin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      child: const Text('Browse Restaurants'),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Section: Order Items
                          const Text(
                            'Order items',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // List of cart items
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              final item = cart[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppTheme.border, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    // Food icon
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(item.foodItem.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    
                                    // Name & additions description
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.foodItem.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          if (item.additions.isNotEmpty || item.packageBox) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              '${item.additions.join(", ")}${item.additions.isNotEmpty && item.packageBox ? " + " : ""}${item.packageBox ? "Package box" : ""}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.textSecondary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                          const SizedBox(height: 6),
                                          Text(
                                            '₹${item.totalItemPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: AppTheme.orange,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Item quantity counter
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.background,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove, size: 14),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                            onPressed: () => state.updateCartQuantity(item, item.quantity - 1),
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add, size: 14),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                            onPressed: () => state.updateCartQuantity(item, item.quantity + 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Recommendations Section
                          if (recItems.isNotEmpty) ...[
                            const Text(
                              'Recommendations',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Horizontal list of recommendations
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: recItems.length,
                                itemBuilder: (context, index) {
                                  final rec = recItems[index];
                                  return Container(
                                    width: 140,
                                    margin: const EdgeInsets.only(right: 12, bottom: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppTheme.border, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage(rec.image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                rec.name,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '₹${rec.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.orange,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              GestureDetector(
                                                onTap: () {
                                                  state.addToCart(rec, 1, [], false);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.orangeLight,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Text(
                                                    '+ Add',
                                                    style: TextStyle(
                                                      color: AppTheme.orange,
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],

                          // Summary details card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.border, width: 1),
                            ),
                            child: Column(
                              children: [
                                _buildSummaryRow('Subtotal', '₹${state.cartSubtotal.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                _buildSummaryRow('Delivery fee', '₹${state.deliveryFee.toStringAsFixed(2)}'),
                                const Divider(color: AppTheme.border, height: 24),
                                _buildSummaryRow(
                                  'Total',
                                  '₹${state.cartTotal.toStringAsFixed(2)}',
                                  isTotal: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Checkout bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to map screen, passing order amount
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryMapScreen(orderTotal: state.cartTotal),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Go to checkout',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•   ₹${state.cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.w800,
            color: isTotal ? AppTheme.orange : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
