import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'delivery_map_screen.dart';

class MockOrder {
  final String id;
  final String restaurantName;
  final String restaurantLogo;
  final String status; // 'Ongoing', 'Completed', 'Cancelled'
  final String date;
  final double totalAmount;
  final List<String> items;

  MockOrder({
    required this.id,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.status,
    required this.date,
    required this.totalAmount,
    required this.items,
  });
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MockOrder> _orders = [
    MockOrder(
      id: 'ORD-8742',
      restaurantName: 'Tandoori Flames',
      restaurantLogo: '🍛',
      status: 'Ongoing',
      date: 'Today, 2:15 PM',
      totalAmount: 460.00,
      items: ['1x Butter Chicken & Naan', '2x Aloo Tikki Burger'],
    ),
    MockOrder(
      id: 'ORD-7612',
      restaurantName: 'La Pasta House',
      restaurantLogo: '🍝',
      status: 'Completed',
      date: '16 July 2026, 8:40 PM',
      totalAmount: 320.00,
      items: ['1x Pesto Pasta', '1x Carbonara Pasta'],
    ),
    MockOrder(
      id: 'ORD-6218',
      restaurantName: 'Burger Club',
      restaurantLogo: '🍔',
      status: 'Completed',
      date: '12 July 2026, 1:15 PM',
      totalAmount: 180.00,
      items: ['1x Spicy Paneer Burger', '1x Juice 250ml (Orange)'],
    ),
    MockOrder(
      id: 'ORD-5541',
      restaurantName: 'Crazy Tacko',
      restaurantLogo: '🌮',
      status: 'Cancelled',
      date: '08 July 2026, 9:30 PM',
      totalAmount: 240.00,
      items: ['2x Shrimp Pizza'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ongoingOrders = _orders.where((o) => o.status == 'Ongoing').toList();
    final pastOrders = _orders.where((o) => o.status != 'Ongoing').toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order History',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.orange,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.orange,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Active Orders'),
            Tab(text: 'Past Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(ongoingOrders, isActive: true),
          _buildOrderList(pastOrders, isActive: false),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<MockOrder> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isActive ? '🚲' : '📦',
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active orders right now' : 'No past orders found',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Order delicious foods to see them here!',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppTheme.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header Information Row
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Brand Logo/Emoji
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        order.restaurantLogo,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Names & ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.restaurantName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.date,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.id,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Chip
                    _buildStatusChip(order.status),
                  ],
                ),
              ),
              
              const Divider(height: 1, color: AppTheme.border),
              
              // 2. Ordered Items List details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ITEMS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: AppTheme.orange),
                          const SizedBox(width: 8),
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              
              const Divider(height: 1, color: AppTheme.border),

              // 3. Totals & Action Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL AMOUNT',
                          style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    // Action Trigger buttons
                    Row(
                      children: [
                        if (order.status == 'Ongoing')
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeliveryMapScreen(orderTotal: order.totalAmount),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.map_outlined, size: 16),
                                SizedBox(width: 6),
                                Text('Track Order', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        if (order.status != 'Ongoing') ...[
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Feedback dialog submitted! Thank you.')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.textSecondary,
                              side: const BorderSide(color: AppTheme.border),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Rate', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Items from ${order.restaurantName} added to cart!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Re-order', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    String text = status;

    if (status == 'Ongoing') {
      bgColor = const Color(0xFFFFF3E0);
      textColor = Colors.orange.shade800;
      text = 'On the Way';
    } else if (status == 'Completed') {
      bgColor = const Color(0xFFE8F5E9);
      textColor = Colors.green.shade800;
      text = 'Delivered';
    } else {
      bgColor = const Color(0xFFFFEBEE);
      textColor = Colors.red.shade800;
      text = 'Cancelled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
