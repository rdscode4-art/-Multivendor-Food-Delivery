import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'welcome_screen.dart';
import 'wallet_screen.dart';
import 'loyalty_membership_screen.dart';
import 'address_management_screen.dart';
import 'referral_screen.dart';
import 'support_tickets_screen.dart';
import 'device_management_screen.dart';
import '../models/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _soundEnabled = true;
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promoOffers = false;
  bool _locationAccess = true;
  bool _biometricLogin = false;
  String _selectedLanguage = 'English (US)';

  final List<String> _languages = [
    'English (US)',
    'Spanish (Español)',
    'Hindi (हिंदी)',
    'French (Français)',
    'German (Deutsch)',
  ];

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (newCtrl.text.isNotEmpty && newCtrl.text == confirmCtrl.text) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password updated successfully!'),
                    backgroundColor: AppTheme.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Delete Account?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Are you sure you want to permanently delete your account? All order history and saved cards will be erased. This action cannot be undone.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textPrimary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              final state = AppStateProvider.of(context, listen: false);
              state.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
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
              // Section 1: General Preferences
              _buildSectionHeader('General Preferences'),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Enable dark theme across the application',
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                ),
                const Divider(height: 1, color: AppTheme.border),
                ListTile(
                  leading: const Icon(Icons.language_outlined, color: AppTheme.orange),
                  title: const Text('App Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(_selectedLanguage, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => ListView(
                        shrinkWrap: true,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Select Language', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ..._languages.map((lang) => ListTile(
                                title: Text(lang),
                                trailing: _selectedLanguage == lang ? const Icon(Icons.check, color: AppTheme.orange) : null,
                                onTap: () {
                                  setState(() => _selectedLanguage = lang);
                                  Navigator.pop(context);
                                },
                              )),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.border),
                _buildSwitchTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Sound & Haptics',
                  subtitle: 'Play sounds on order status updates',
                  value: _soundEnabled,
                  onChanged: (val) => setState(() => _soundEnabled = val),
                ),
              ]),

              const SizedBox(height: 24),

              // Section: Account Dashboards
              _buildSectionHeader('Account Dashboards'),
              _buildSettingsCard([
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.orange),
                  title: const Text('My Wallet Cash', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WalletScreen()),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.border),
                ListTile(
                  leading: const Icon(Icons.stars_outlined, color: AppTheme.orange),
                  title: const Text('VIP & Loyalty Membership', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoyaltyMembershipScreen()),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.border),
                ListTile(
                  leading: const Icon(Icons.map_outlined, color: AppTheme.orange),
                  title: const Text('Saved Delivery Addresses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddressManagementScreen(selectMode: false)),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.border),
                ListTile(
                  leading: const Icon(Icons.card_giftcard_outlined, color: AppTheme.orange),
                  title: const Text('Refer & Earn ₹100', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReferralScreen()),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.border),
                ListTile(
                  leading: const Icon(Icons.support_agent_outlined, color: AppTheme.orange),
                  title: const Text('Support Ticket Desk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SupportTicketsScreen()),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.border),
                ListTile(
                  leading: const Icon(Icons.devices_outlined, color: AppTheme.orange),
                  title: const Text('Device Management & Logouts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DeviceManagementScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 24),

              // Section 2: Notifications
              _buildSectionHeader('Notifications'),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive general push notifications',
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const Divider(height: 1, color: AppTheme.border),
                _buildSwitchTile(
                  icon: Icons.delivery_dining_outlined,
                  title: 'Order Status Updates',
                  subtitle: 'Real-time updates on food preparation & delivery',
                  value: _orderUpdates,
                  onChanged: (val) => setState(() => _orderUpdates = val),
                ),
                const Divider(height: 1, color: AppTheme.border),
                _buildSwitchTile(
                  icon: Icons.local_offer_outlined,
                  title: 'Promotions & Discounts',
                  subtitle: 'Get notified about exclusive deals & coupons',
                  value: _promoOffers,
                  onChanged: (val) => setState(() => _promoOffers = val),
                ),
              ]),

              const SizedBox(height: 24),

              // Section 3: Privacy & Security
              _buildSectionHeader('Privacy & Security'),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.location_on_outlined,
                  title: 'Location Permissions',
                  subtitle: 'Allow precise location for faster delivery',
                  value: _locationAccess,
                  onChanged: (val) => setState(() => _locationAccess = val),
                ),
                const Divider(height: 1, color: AppTheme.border),
                _buildSwitchTile(
                  icon: Icons.fingerprint_outlined,
                  title: 'Biometric Security',
                  subtitle: 'Use Face ID or Fingerprint for quick checkout',
                  value: _biometricLogin,
                  onChanged: (val) => setState(() => _biometricLogin = val),
                ),
              ]),

              const SizedBox(height: 24),

              // Section 4: Account Actions
              _buildSectionHeader('Account Actions'),
              _buildSettingsCard([
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: AppTheme.orange),
                  title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: _showChangePasswordDialog,
                ),
                const Divider(height: 1, color: AppTheme.border),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: AppTheme.orange),
                  title: const Text('Terms of Service & Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Terms & Privacy Policy...')),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.border),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.red),
                  onTap: _showDeleteAccountDialog,
                ),
              ]),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppTheme.orange,
      activeColor: Colors.white,
      secondary: Icon(icon, color: AppTheme.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
    );
  }
}
