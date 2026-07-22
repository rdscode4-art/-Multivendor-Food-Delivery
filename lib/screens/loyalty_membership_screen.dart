import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';

class LoyaltyMembershipScreen extends StatefulWidget {
  const LoyaltyMembershipScreen({super.key});

  @override
  State<LoyaltyMembershipScreen> createState() => _LoyaltyMembershipScreenState();
}

class _LoyaltyMembershipScreenState extends State<LoyaltyMembershipScreen> {
  bool _isProcessing = false;
  bool _isAdminMode = false;

  // Form Fields for new Plan
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _multiplierController = TextEditingController();
  final _deliveryController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _multiplierController.dispose();
    _deliveryController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _redeemPoints(int points, AppState state) {
    if (points <= 0 || state.loyaltyPoints < points) return;

    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      state.redeemLoyaltyPoints(points);
      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully redeemed $points points for ₹${(points / 10).toStringAsFixed(2)} cashback!'),
          backgroundColor: AppTheme.green,
        ),
      );
    });
  }

  void _upgradePlan(String planName, AppState state) {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      state.upgradeVipMembership(planName);
      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('VIP membership upgraded to $planName!'),
          backgroundColor: AppTheme.green,
        ),
      );
    });
  }

  void _createNewPlan(AppState state) {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      state.addMembershipPlan(
        _nameController.text.trim(),
        _priceController.text.trim(),
        _multiplierController.text.trim(),
        _deliveryController.text.trim(),
        _discountController.text.trim(),
      );

      // Clear Form Fields
      _nameController.clear();
      _priceController.clear();
      _multiplierController.clear();
      _deliveryController.clear();
      _discountController.clear();

      setState(() {
        _isProcessing = false;
        _isAdminMode = false; // Return to standard view
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Custom VIP Membership Plan created successfully!'),
          backgroundColor: AppTheme.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final points = state.loyaltyPoints;
    final activePlan = state.vipMembership;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(_isAdminMode ? 'VIP Admin Panel' : 'Loyalty & Membership'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isAdminMode ? Icons.account_circle : Icons.admin_panel_settings,
              color: _isAdminMode ? Colors.white : const Color(0xFFFFB300),
            ),
            tooltip: _isAdminMode ? 'View as Customer' : 'View as Admin',
            onPressed: () {
              setState(() {
                _isAdminMode = !_isAdminMode;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isAdminMode ? _buildAdminModeBody(state) : _buildCustomerModeBody(state, points, activePlan),
    );
  }

  Widget _buildCustomerModeBody(AppState state, int points, String activePlan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Loyalty Points Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE21B32), Color(0xFFFF8C67)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE21B32).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.stars, color: Colors.white, size: 44),
                const SizedBox(height: 10),
                const Text(
                  'Loyalty Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '$points Points',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                const Text(
                  '10 Points = ₹1.00 Cash back',
                  style: TextStyle(color: Colors.white60, fontSize: 11, fontStyle: FontStyle.italic),
                ),
                if (points >= 100) ...[
                  const Divider(color: Colors.white24, height: 24),
                  ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () => _redeemPoints((points ~/ 100) * 100, state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFE21B32),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(color: Color(0xFFE21B32), strokeWidth: 2),
                          )
                        : Text('Redeem ${(points ~/ 100) * 100} Points', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Birthday Offer Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('🎂', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Birthday Special Gift!',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Celebrate your birthday with a FREE dessert voucher and 200 bonus loyalty points.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // VIP Membership Plans
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'VIP Membership Plans',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              if (state.membershipPlans.length > 3)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Custom Plans Added',
                    style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.membershipPlans.length,
            itemBuilder: (context, index) {
              final plan = state.membershipPlans[index];
              return _buildPlanCard(
                name: plan.name,
                price: plan.price,
                pointsMultiplier: plan.pointsMultiplier,
                freeDelivery: plan.freeDelivery,
                discounts: plan.discounts,
                isActive: activePlan.toLowerCase().contains(plan.name.split(' ').first.toLowerCase()),
                onTap: () => _upgradePlan(plan.name, state),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminModeBody(AppState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.settings_suggest, size: 60, color: Color(0xFF900B1A)),
            const SizedBox(height: 10),
            const Text(
              'Create VIP Membership Plan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Fill the configuration form to launch a new membership model instantly to all users.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 36, color: AppTheme.border),

            // Plan Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Plan Title Name',
                hintText: 'e.g. Diamond VIP Plan',
                prefixIcon: const Icon(Icons.badge, color: AppTheme.orange),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter plan name' : null,
            ),
            const SizedBox(height: 16),

            // Pricing field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price description',
                hintText: 'e.g. ₹399 / month',
                prefixIcon: const Icon(Icons.monetization_on, color: AppTheme.orange),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter pricing detail' : null,
            ),
            const SizedBox(height: 16),

            // Points Multiplier field
            TextFormField(
              controller: _multiplierController,
              decoration: InputDecoration(
                labelText: 'Points Multiplier Benefit',
                hintText: 'e.g. 2.5x points on all orders',
                prefixIcon: const Icon(Icons.bolt, color: AppTheme.orange),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter multiplier details' : null,
            ),
            const SizedBox(height: 16),

            // Free Delivery field
            TextFormField(
              controller: _deliveryController,
              decoration: InputDecoration(
                labelText: 'Free Delivery Benefit',
                hintText: 'e.g. Free delivery on orders above ₹99',
                prefixIcon: const Icon(Icons.local_shipping, color: AppTheme.orange),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter delivery threshold' : null,
            ),
            const SizedBox(height: 16),

            // Discounts field
            TextFormField(
              controller: _discountController,
              decoration: InputDecoration(
                labelText: 'Special Discounts / Cashback Benefits',
                hintText: 'e.g. Extra 15% discount on Bestsellers',
                prefixIcon: const Icon(Icons.percent, color: AppTheme.orange),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter discount rules' : null,
            ),
            const SizedBox(height: 28),

            // Submit Button
            ElevatedButton(
              onPressed: _isProcessing ? null : () => _createNewPlan(state),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE21B32),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Launch Membership Plan',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _isAdminMode = false;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Cancel & Go Back', style: TextStyle(color: AppTheme.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String name,
    required String price,
    required String pointsMultiplier,
    required String freeDelivery,
    required String discounts,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFFE21B32) : AppTheme.border,
          width: isActive ? 2.0 : 1.0,
        ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFFF3E0) : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isActive ? const Color(0xFFE21B32) : AppTheme.textPrimary,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildBenefitRow(Icons.bolt, pointsMultiplier),
                const SizedBox(height: 8),
                _buildBenefitRow(Icons.local_shipping, freeDelivery),
                const SizedBox(height: 8),
                _buildBenefitRow(Icons.percent, discounts),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isActive ? null : onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive ? AppTheme.green : const Color(0xFFE21B32),
                    disabledBackgroundColor: AppTheme.green,
                    minimumSize: const Size(double.infinity, 46),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isActive ? 'Active Membership' : 'Activate Plan',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String benefit) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE21B32), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            benefit,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
