import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../widgets/levitating_3d_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String _selectedGender = 'Female';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController(text: '+1 (555) 234-5678');
    _addressController = TextEditingController(text: '742 Evergreen Terrace, Springfield');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = AppStateProvider.of(context, listen: false).user;
    if (_nameController.text.isEmpty) {
      _nameController.text = user.name;
    }
    if (_emailController.text.isEmpty) {
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final state = AppStateProvider.of(context, listen: false);
      state.login(_emailController.text.trim(), _nameController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Profile updated successfully!'),
            ],
          ),
          backgroundColor: AppTheme.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final user = state.user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Avatar with edit camera button
                Center(
                  child: Levitating3DAvatar(
                    photoUrl: user.photo,
                    radius: 54,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Camera picker opened'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Form Fields
                _buildFieldLabel('Full Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.orange),
                    hintText: 'Enter full name',
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Name cannot be empty' : null,
                ),
                const SizedBox(height: 20),

                _buildFieldLabel('Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: AppTheme.orange),
                    hintText: 'Enter email address',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email cannot be empty';
                    if (!val.contains('@')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildFieldLabel('Phone Number'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.orange),
                    hintText: 'Enter phone number',
                  ),
                ),
                const SizedBox(height: 20),

                _buildFieldLabel('Delivery Address'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.orange),
                    hintText: 'Enter delivery address',
                  ),
                ),
                const SizedBox(height: 20),

                _buildFieldLabel('Gender'),
                const SizedBox(height: 8),
                Row(
                  children: ['Female', 'Male', 'Other'].map((gender) {
                    final isSelected = _selectedGender == gender;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = gender),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.orangeLight : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppTheme.orange : AppTheme.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              gender,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppTheme.orange : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 36),

                // Save Button
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppTheme.orange.withOpacity(0.4),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }
}
