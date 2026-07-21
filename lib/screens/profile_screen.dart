import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'welcome_screen.dart';
import 'order_history_screen.dart';
import 'edit_profile_screen.dart';
import 'payment_methods_screen.dart';
import 'contact_us_screen.dart';
import 'settings_screen.dart';
import 'help_faq_screen.dart';
import '../widgets/levitating_3d_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final user = state.user;
    final favCount = state.favoriteFoodIds.length + state.favoriteRestaurantIds.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Account Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppTheme.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Card Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Levitating3DAvatar(
                      photoUrl: user.photo,
                      radius: 46,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick User Stats Counter Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('12', 'Orders'),
                        Container(height: 30, width: 1, color: AppTheme.border),
                        _buildStatColumn('$favCount', 'Favorites'),
                        Container(height: 30, width: 1, color: AppTheme.border),
                        _buildStatColumn('2', 'Saved Cards'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu List
              const Text(
                'Menu & Settings',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'My Profile',
                subtitle: 'Manage name, address & details',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View active & past food orders',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery Address',
                subtitle: 'Add or update saved addresses',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                subtitle: 'Saved cards, UPI & wallets',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.mail_outline,
                title: 'Contact Us',
                subtitle: 'Customer care hotline & feedback',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactUsScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Notifications, language & security',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline_outlined,
                title: 'Help & FAQ',
                subtitle: 'Frequently asked questions & guide',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpFaqScreen()),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Log out Button
              OutlinedButton.icon(
                onPressed: () {
                  state.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: AppTheme.orange, size: 20),
                label: const Text(
                  'Log out',
                  style: TextStyle(color: AppTheme.orange, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.orange, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.orange,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.orangeLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.orange, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary, size: 14),
      ),
    );
  }
}
