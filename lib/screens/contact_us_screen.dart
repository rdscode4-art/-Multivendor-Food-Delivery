import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'Order Delay';

  final List<String> _categories = [
    'Order Delay',
    'Payment Issue',
    'Food Quality',
    'Account & App',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.orangeLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mark_email_read_outlined, color: AppTheme.orange, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Message Sent!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thank you for reaching out. Our support team will get back to you within 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // return back
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Contact Us'),
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
              // Hero Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.navy, Color(0xFF2C3E50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.navy.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "We're here to help!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Have questions or feedback? Contact our 24/7 customer support team.',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppTheme.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.headset_mic_outlined, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Contact Grid
              const Text(
                'Quick Contact',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      icon: Icons.phone_in_talk_outlined,
                      title: 'Call Support',
                      subtitle: '+1 800 123 4567',
                      color: AppTheme.orange,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling +1 800 123 4567...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactCard(
                      icon: Icons.email_outlined,
                      title: 'Email Us',
                      subtitle: 'support@foodies.com',
                      color: const Color(0xFF3B5998),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening mail app...')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      icon: Icons.chat_bubble_outline,
                      title: 'Live Chat',
                      subtitle: 'Available 24/7',
                      color: AppTheme.green,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Starting Live Support Chat...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactCard(
                      icon: Icons.location_on_outlined,
                      title: 'Our Office',
                      subtitle: 'Springfield, NY',
                      color: const Color(0xFF8E44AD),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening map location...')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Send Message Form
              const Text(
                'Send us a message',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Issue Category',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),
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
                                fontSize: 12,
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
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        prefixIcon: Icon(Icons.subtitles_outlined, color: AppTheme.orange),
                        hintText: 'Brief topic of your inquiry',
                      ),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Subject is required' : null,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        alignLabelWithHint: true,
                        hintText: 'Describe your issue or feedback in detail...',
                      ),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Message cannot be empty' : null,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _sendMessage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
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

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
