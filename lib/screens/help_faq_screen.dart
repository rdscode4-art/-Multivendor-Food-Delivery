import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'contact_us_screen.dart';

class FaqItem {
  final String question;
  final String answer;
  final String category;

  FaqItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Orders',
    'Payment',
    'Delivery',
    'Account',
    'Offers',
  ];

  final List<FaqItem> _faqs = [
    FaqItem(
      category: 'Orders',
      question: 'How do I track my order in real-time?',
      answer:
          'Once your order is confirmed, go to "My Orders" from your Profile tab or tap on the active order banner on the home screen to view live rider GPS status and estimated delivery time.',
    ),
    FaqItem(
      category: 'Orders',
      question: 'Can I modify or cancel my order after placing it?',
      answer:
          'Orders can be canceled free of charge within 60 seconds of placing them. After the restaurant starts preparing your food, cancellations may incur a fee depending on preparation progress.',
    ),
    FaqItem(
      category: 'Payment',
      question: 'What payment methods are accepted on Foodies?',
      answer:
          'We accept Credit & Debit cards (Visa, MasterCard), UPI (Google Pay, PhonePe, Paytm), Net Banking, and Cash on Delivery (COD).',
    ),
    FaqItem(
      category: 'Payment',
      question: 'How long does a refund take to reflect in my bank?',
      answer:
          'Refunds for canceled or failed orders are initiated immediately. Card refunds take 3-5 business days, while UPI refunds reflect within 24 hours.',
    ),
    FaqItem(
      category: 'Delivery',
      question: 'What should I do if food is missing or damaged?',
      answer:
          'We are deeply sorry for any inconvenience! Please navigate to Contact Us or open your order details to report missing/damaged items, and our support team will issue an instant refund or replacement.',
    ),
    FaqItem(
      category: 'Delivery',
      question: 'How do I change my default delivery address?',
      answer:
          'You can change or add new delivery addresses in "My Profile" -> "Delivery Address" or directly on the checkout screen before placing your order.',
    ),
    FaqItem(
      category: 'Offers',
      question: 'How do I apply promo codes and coupons?',
      answer:
          'During checkout, tap on "Apply Coupon Code" in the cart summary page, enter your promo code, and tap Apply to receive an instant discount.',
    ),
    FaqItem(
      category: 'Account',
      question: 'How do I update my profile details or phone number?',
      answer:
          'Go to the Profile tab, tap "My Profile", update your full name, email, or phone number, and tap "Save Changes".',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter FAQs based on category and search query
    final filteredFaqs = _faqs.where((faq) {
      final matchesCategory =
          _selectedCategory == 'All' || faq.category == _selectedCategory;
      final matchesSearch = faq.question
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Help & FAQ'),
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
              // Search Input Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search questions, keywords...',
                    prefixIcon: Icon(Icons.search, color: AppTheme.orange),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                        selectedColor: AppTheme.orange,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppTheme.orange : AppTheme.border,
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // FAQ List Header
              Text(
                'Frequently Asked Questions (${filteredFaqs.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              if (filteredFaqs.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  child: Column(
                    children: const [
                      Icon(Icons.find_in_page_outlined, size: 48, color: AppTheme.textMuted),
                      SizedBox(height: 12),
                      Text(
                        'No matching questions found',
                        style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Try searching with different keywords or browse categories.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                )
              else
                ...filteredFaqs.map((faq) => _buildFaqCard(faq)),

              const SizedBox(height: 32),

              // Still Need Help Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.orangeLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.orange.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.support_agent_rounded, size: 40, color: AppTheme.orange),
                    const SizedBox(height: 10),
                    const Text(
                      'Still need help?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Can't find the answer you are looking for? Please contact our support team.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ContactUsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Contact Support'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(FaqItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppTheme.orange,
          collapsedIconColor: AppTheme.textSecondary,
          title: Text(
            faq.question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.textPrimary,
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.orangeLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.help_outline, color: AppTheme.orange, size: 18),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 4),
              child: Text(
                faq.answer,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
