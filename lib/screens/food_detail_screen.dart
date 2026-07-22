import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../widgets/appzeto_animations.dart';
import 'cart_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem foodItem;
  const FoodDetailScreen({super.key, required this.foodItem});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  final List<String> _selectedAdditions = [];
  bool _packageBoxSelected = false;
  final TextEditingController _customIngredientController = TextEditingController();
  String _customIngredientText = '';

  @override
  void dispose() {
    _customIngredientController.dispose();
    super.dispose();
  }

  void _toggleAddition(String add) {
    setState(() {
      if (_selectedAdditions.contains(add)) {
        _selectedAdditions.remove(add);
      } else {
        _selectedAdditions.add(add);
      }
    });
  }

  double _calculateUnitPrice() {
    double base = widget.foodItem.price;
    if (_selectedAdditions.contains('Parmesan cheese')) base += 2.50;
    if (_selectedAdditions.contains('Sauce')) base += 1.50;
    if (_selectedAdditions.contains('Extra Cheese')) base += 30.00;
    if (_selectedAdditions.contains('Extra Paneer/Tofu')) base += 40.00;
    if (_selectedAdditions.contains('Fresh Mushrooms')) base += 25.00;
    if (_selectedAdditions.contains('Spicy Jalapenos')) base += 20.00;
    if (_packageBoxSelected) base += 0.50;
    return base;
  }

  double _calculateTotalPrice() {
    return _calculateUnitPrice() * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final food = widget.foodItem;
    final isFav = state.favoriteFoodIds.contains(food.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Food Image Area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Hero(
              tag: 'food-img-${food.id}',
              child: Image.network(
                food.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Header buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppTheme.orange : AppTheme.textSecondary,
                    ),
                    onPressed: () => state.toggleFavoriteFood(food.id),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable details panel
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            bottom: 90, // space for bottom quantity & button bar
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title, rating & time
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppTheme.ratingYellow, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${food.rating}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time, color: AppTheme.textSecondary, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          food.deliveryTime,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Price
                    Row(
                      children: [
                        Text(
                          '₹${food.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.orange,
                          ),
                        ),
                        if (food.oldPrice != null) ...[
                          const SizedBox(width: 10),
                          Text(
                            '₹${food.oldPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Divider(color: AppTheme.border, height: 32),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      food.description,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 24),

                    // Add more section
                    const Text(
                      'Add more & Ingredients',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _buildCustomOption(
                      'Parmesan cheese',
                      r'+₹2.50',
                      _selectedAdditions.contains('Parmesan cheese'),
                      () => _toggleAddition('Parmesan cheese'),
                    ),
                    _buildCustomOption(
                      'Sauce',
                      r'+₹1.50',
                      _selectedAdditions.contains('Sauce'),
                      () => _toggleAddition('Sauce'),
                    ),
                    _buildCustomOption(
                      'Extra Cheese',
                      r'+₹30.00',
                      _selectedAdditions.contains('Extra Cheese'),
                      () => _toggleAddition('Extra Cheese'),
                    ),
                    _buildCustomOption(
                      'Extra Paneer/Tofu',
                      r'+₹40.00',
                      _selectedAdditions.contains('Extra Paneer/Tofu'),
                      () => _toggleAddition('Extra Paneer/Tofu'),
                    ),
                    _buildCustomOption(
                      'Fresh Mushrooms',
                      r'+₹25.00',
                      _selectedAdditions.contains('Fresh Mushrooms'),
                      () => _toggleAddition('Fresh Mushrooms'),
                    ),
                    _buildCustomOption(
                      'Spicy Jalapenos',
                      r'+₹20.00',
                      _selectedAdditions.contains('Spicy Jalapenos'),
                      () => _toggleAddition('Spicy Jalapenos'),
                    ),
                    const SizedBox(height: 20),

                    // Custom instructions/ingredient adder
                    const Text(
                      'Custom Ingredient / Note',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _customIngredientController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Extra spicy, No onions, Add extra oregano...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                        filled: true,
                        fillColor: AppTheme.background,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                      onChanged: (val) {
                        _customIngredientText = val;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Package section
                    const Text(
                      'Package',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _buildCustomOption(
                      'Package box cost',
                      r'+₹0.50',
                      _packageBoxSelected,
                      () {
                        setState(() {
                          _packageBoxSelected = !_packageBoxSelected;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar: Quantity & Add to Cart
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 90,
            child: Container(
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
              child: Row(
                children: [
                  // Quantity Counter
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 16, color: AppTheme.textPrimary),
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 16, color: AppTheme.textPrimary),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  // Add Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final additions = List<String>.from(_selectedAdditions);
                        if (_customIngredientText.trim().isNotEmpty) {
                          additions.add('Instruction: ${_customIngredientText.trim()}');
                        }
                        state.addToCart(
                          food,
                          _quantity,
                          additions,
                          _packageBoxSelected,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${food.name} added to cart!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        // Redirect to the Cart screen
                        Navigator.push(
                          context,
                          AppzetoPageRoute(page: const CartScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Add to order   ₹${_calculateTotalPrice().toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomOption(String name, String price, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_off,
              color: isSelected ? AppTheme.orange : AppTheme.textMuted,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
