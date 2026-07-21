import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/interactive_3d_card.dart';

class PaymentMethodItem {
  final String id;
  final String name;
  final String details;
  final String type; // 'card', 'upi', 'cod'
  final Color cardBgColor;
  final List<Color>? gradientColors;
  bool isDefault;

  PaymentMethodItem({
    required this.id,
    required this.name,
    required this.details,
    required this.type,
    this.cardBgColor = Colors.white,
    this.gradientColors,
    this.isDefault = false,
  });
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<PaymentMethodItem> _methods = [
    PaymentMethodItem(
      id: 'p1',
      name: 'Katty Berry',
      details: '•••• •••• •••• 4242',
      type: 'card',
      gradientColors: [const Color(0xFF1F1C2C), const Color(0xFF928DAB)],
      isDefault: true,
    ),
    PaymentMethodItem(
      id: 'p2',
      name: 'Katty Berry',
      details: '•••• •••• •••• 8891',
      type: 'card',
      gradientColors: [const Color(0xFFFE5526), const Color(0xFFFF9E79)],
      isDefault: false,
    ),
    PaymentMethodItem(
      id: 'p3',
      name: 'Google Pay / UPI',
      details: 'kattyberry@okaxis',
      type: 'upi',
      isDefault: false,
    ),
    PaymentMethodItem(
      id: 'p4',
      name: 'Cash on Delivery',
      details: 'Pay with cash or QR upon delivery',
      type: 'cod',
      isDefault: false,
    ),
  ];

  void _setDefault(String id) {
    setState(() {
      for (var item in _methods) {
        item.isDefault = item.id == id;
      }
    });
  }

  void _removeMethod(String id) {
    setState(() {
      _methods.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment method removed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAddCardBottomSheet() {
    final nameCtrl = TextEditingController();
    final numberCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add New Payment Card',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.orange),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: numberCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  prefixIcon: Icon(Icons.credit_card, color: AppTheme.orange),
                  hintText: '1234 5678 9012 3456',
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryCtrl,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: 'Expiry (MM/YY)',
                        hintText: '12/28',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: cvvCtrl,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '***',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (numberCtrl.text.isNotEmpty) {
                    final last4 = numberCtrl.text.length >= 4
                        ? numberCtrl.text.substring(numberCtrl.text.length - 4)
                        : '1234';
                    setState(() {
                      _methods.add(
                        PaymentMethodItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameCtrl.text.isNotEmpty ? nameCtrl.text : 'Card Holder',
                          details: '•••• •••• •••• $last4',
                          type: 'card',
                          gradientColors: [
                            const Color(0xFF0F2027),
                            const Color(0xFF2C5364),
                          ],
                        ),
                      );
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Card added successfully!'),
                        backgroundColor: AppTheme.green,
                      ),
                    );
                  }
                },
                child: const Text('Add Card', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = _methods.where((m) => m.type == 'card').toList();
    final otherMethods = _methods.where((m) => m.type != 'card').toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Payment Methods'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section Header & Interactive 3D Hint
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Saved Cards',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.rotate_right, color: AppTheme.orange, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Tap to 3D Flip',
                        style: TextStyle(
                          color: AppTheme.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Interactive 3D Credit Cards
              if (cards.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Center(
                    child: Text('No saved cards yet', style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                )
              else
                ...cards.map(
                  (card) => Interactive3DCard(
                    card: card,
                    onSetDefault: () => _setDefault(card.id),
                    onDelete: () => _removeMethod(card.id),
                  ),
                ),

              const SizedBox(height: 24),

              // UPI & Other Methods
              const Text(
                'Other Payment Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              ...otherMethods.map((method) => _buildOtherMethodTile(method)),

              const SizedBox(height: 32),

              // Add New Card Button
              OutlinedButton.icon(
                onPressed: _showAddCardBottomSheet,
                icon: const Icon(Icons.add_circle_outline, color: AppTheme.orange),
                label: const Text(
                  'Add New Payment Card',
                  style: TextStyle(color: AppTheme.orange, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.orange, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherMethodTile(PaymentMethodItem method) {
    final isUpi = method.type == 'upi';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: method.isDefault ? AppTheme.orange : AppTheme.border,
          width: method.isDefault ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        onTap: () => _setDefault(method.id),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.orangeLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isUpi ? Icons.account_balance_wallet_outlined : Icons.payments_outlined,
            color: AppTheme.orange,
            size: 24,
          ),
        ),
        title: Text(
          method.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          method.details,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        trailing: Icon(
          method.isDefault ? Icons.radio_button_checked : Icons.radio_button_off,
          color: method.isDefault ? AppTheme.orange : AppTheme.textMuted,
        ),
      ),
    );
  }
}
