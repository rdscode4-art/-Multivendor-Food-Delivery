import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'delivery_map_screen.dart';
import 'address_management_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  String _deliveryMode = 'Instant';
  String _scheduledTime = 'Select Time';
  bool _useWallet = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final cart = state.cart;

    // Filter recommended foods that aren't already in the cart
    final recItems = state.foodItems.where((food) {
      return !cart.any((cartItem) => cartItem.foodItem.id == food.id) &&
          (food.category == 'Dessert' || food.category == 'Drinks');
    }).toList();

    // Price Calculations
    final subtotal = state.cartSubtotal;
    final tax = subtotal * 0.05;
    const platformFee = 2.00;
    final smallOrderFee = (subtotal < 150.0 && subtotal > 0.0) ? 10.00 : 0.0;
    final surgeFee = subtotal > 0.0 ? 15.00 : 0.0;
    
    double deliveryFee = state.deliveryFee;
    if (state.appliedCouponCode == 'FREEDEL') {
      deliveryFee = 0.0;
    }
    
    double discount = 0.0;
    if (state.appliedCouponCode == 'WELCOME50') {
      discount = 50.0;
    }

    final grossTotal = max(0.0, subtotal + tax + platformFee + smallOrderFee + surgeFee + deliveryFee - discount);
    
    double walletDeduction = 0.0;
    if (_useWallet) {
      walletDeduction = min(state.walletBalance, grossTotal);
    }
    
    final netTotal = max(0.0, grossTotal - walletDeduction);

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

                          // Delivery Address Selector Section
                          const Text(
                            'Delivery Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Column(
                              children: [
                                if (state.selectedAddress != null) ...[
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: AppTheme.orange, size: 24),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.selectedAddress!.label,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              state.selectedAddress!.fullAddress,
                                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  const Center(
                                    child: Text(
                                      'No delivery address selected!',
                                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                ],
                                const Divider(height: 24),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddressManagementScreen(selectMode: true),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.map_outlined, color: AppTheme.orange, size: 16),
                                  label: const Text('Change or Add Address', style: TextStyle(color: AppTheme.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppTheme.orange),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Delivery Mode Selector Section
                          const Text(
                            'Delivery Mode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text('Instant', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        value: 'Instant',
                                        groupValue: _deliveryMode,
                                        activeColor: AppTheme.orange,
                                        contentPadding: EdgeInsets.zero,
                                        onChanged: (val) {
                                          setState(() => _deliveryMode = val ?? 'Instant');
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text('Schedule', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        value: 'Schedule',
                                        groupValue: _deliveryMode,
                                        activeColor: AppTheme.orange,
                                        contentPadding: EdgeInsets.zero,
                                        onChanged: (val) {
                                          setState(() => _deliveryMode = val ?? 'Schedule');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                if (_deliveryMode == 'Schedule') ...[
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Schedule Time:', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                                      TextButton.icon(
                                        onPressed: () async {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (time != null) {
                                            setState(() {
                                              _scheduledTime = time.format(context);
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.access_time, size: 16, color: AppTheme.orange),
                                        label: Text(_scheduledTime, style: const TextStyle(color: AppTheme.orange, fontWeight: FontWeight.bold, fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                ]
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Promo Coupon Section
                          const Text(
                            'Promo Coupon',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_offer_outlined, color: AppTheme.orange, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _couponController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter coupon code (e.g. WELCOME50)',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                if (state.appliedCouponCode != null) ...[
                                  Text(
                                    '${state.appliedCouponCode} Applied',
                                    style: const TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold, fontSize: 11),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        state.removeCoupon();
                                        _couponController.clear();
                                      });
                                    },
                                  ),
                                ] else ...[
                                  TextButton(
                                    onPressed: () {
                                      final code = _couponController.text.trim();
                                      if (code.isNotEmpty) {
                                        final success = state.applyCoupon(code);
                                        if (success) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Coupon applied successfully!'), backgroundColor: AppTheme.green),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Invalid coupon code!'), backgroundColor: Colors.redAccent),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('Apply', style: TextStyle(color: AppTheme.orange, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Pay with Wallet Option
                          if (state.walletBalance > 0) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: CheckboxListTile(
                                value: _useWallet,
                                activeColor: AppTheme.orange,
                                onChanged: (val) {
                                  setState(() {
                                    _useWallet = val ?? false;
                                  });
                                },
                                title: const Text('Pay with Wallet Cash', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                subtitle: Text('Balance: ₹${state.walletBalance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Summary details card with transparent breakdown
                          const Text(
                            'Price Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.border, width: 1),
                            ),
                            child: Column(
                              children: [
                                _buildSummaryRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                _buildSummaryRow('Taxes & GST (5%)', '₹${tax.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                _buildSummaryRow('Platform Fee', '₹${platformFee.toStringAsFixed(2)}'),
                                if (smallOrderFee > 0) ...[
                                  const SizedBox(height: 8),
                                  _buildSummaryRow('Small Order Fee', '₹${smallOrderFee.toStringAsFixed(2)}'),
                                ],
                                if (surgeFee > 0) ...[
                                  const SizedBox(height: 8),
                                  _buildSummaryRow('Surge Fee (Peak hours)', '₹${surgeFee.toStringAsFixed(2)}'),
                                ],
                                const SizedBox(height: 8),
                                _buildSummaryRow('Delivery fee', '₹${deliveryFee.toStringAsFixed(2)}'),
                                if (discount > 0) ...[
                                  const SizedBox(height: 8),
                                  _buildSummaryRow('Promo Discount', '- ₹${discount.toStringAsFixed(2)}', isDiscount: true),
                                ],
                                if (walletDeduction > 0) ...[
                                  const SizedBox(height: 8),
                                  _buildSummaryRow('Wallet Deduction', '- ₹${walletDeduction.toStringAsFixed(2)}', isDiscount: true),
                                ],
                                const Divider(color: AppTheme.border, height: 24),
                                _buildSummaryRow(
                                  'Total Payable',
                                  '₹${netTotal.toStringAsFixed(2)}',
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
                      onPressed: state.selectedAddress == null
                          ? null
                          : () {
                              if (_deliveryMode == 'Schedule' && _scheduledTime == 'Select Time') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please select a schedule time slot!'), backgroundColor: Colors.redAccent),
                                );
                                return;
                              }

                              if (_useWallet && walletDeduction > 0) {
                                state.payWithWallet(walletDeduction);
                              }

                              // Navigate to map screen, passing order amount
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeliveryMapScreen(orderTotal: netTotal),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.orange,
                        disabledBackgroundColor: Colors.grey.shade300,
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
                            '•   ₹${netTotal.toStringAsFixed(2)}',
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

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
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
            color: isDiscount 
                ? AppTheme.green 
                : (isTotal ? AppTheme.orange : AppTheme.textPrimary),
          ),
        ),
      ],
    );
  }
}
