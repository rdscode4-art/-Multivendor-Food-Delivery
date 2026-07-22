import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import '../services/api_service.dart';
import 'main_container.dart';
import 'new_password_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String name;
  final bool isPasswordReset;
  final String purpose;
  final String? initialOtp;

  const VerificationScreen({
    super.key,
    required this.email,
    required this.name,
    this.isPasswordReset = false,
    this.purpose = 'signup',
    this.initialOtp,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<String> _code = ['', '', '', ''];
  int _currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialOtp != null && widget.initialOtp!.isNotEmpty) {
      final digits = widget.initialOtp!.trim().split('');
      for (int i = 0; i < 4 && i < digits.length; i++) {
        _code[i] = digits[i];
      }
      _currentIndex = _code.where((c) => c.isNotEmpty).length;
    }
  }

  void _onKeyPress(String val) {
    if (_isLoading) return;
    if (_currentIndex < 4) {
      setState(() {
        _code[_currentIndex] = val;
        _currentIndex++;
      });
      
      if (_currentIndex == 4) {
        _verifyCode();
      }
    }
  }

  void _onBackspace() {
    if (_isLoading) return;
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _code[_currentIndex] = '';
      });
    }
  }

  void _verifyCode() async {
    final verificationCode = _code.join();
    if (verificationCode.length != 4) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final actualPurpose = widget.isPasswordReset ? 'reset_password' : widget.purpose;
      await ApiService.instance.verifyOtp(
        email: widget.email,
        code: verificationCode,
        purpose: actualPurpose,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification Successful!'),
          backgroundColor: Colors.green,
        ),
      );
      
      if (widget.isPasswordReset) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewPasswordScreen(
              email: widget.email,
              code: verificationCode,
            ),
          ),
        );
      } else {
        AppStateProvider.of(context, listen: false).login(widget.email, widget.name);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainContainer()),
          (route) => false,
        );
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Verification Code',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please enter the verification code that has been sent to ${widget.email}',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Code input boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      final hasValue = _code[index].isNotEmpty;
                      final isCurrent = index == _currentIndex;
                      return Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCurrent 
                              ? AppTheme.orange 
                              : (hasValue ? AppTheme.textPrimary : AppTheme.border),
                            width: isCurrent ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          _code[index],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  
                  // Resend Code text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Haven't received a code? ",
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            final actualPurpose = widget.isPasswordReset ? 'reset_password' : widget.purpose;
                            final responseData = await ApiService.instance.resendOtp(
                              email: widget.email,
                              purpose: actualPurpose,
                            );
                            String? code;
                            if (responseData is Map) {
                              code = responseData['code']?.toString() ?? responseData['otp']?.toString();
                            }
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(code != null ? 'A new code has been sent ($code)!' : 'A new code has been sent!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to resend OTP: ${e.toString()}'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                            color: AppTheme.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Numeric Keyboard Widget at bottom
          Container(
            color: AppTheme.background,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                _buildKeyboardRow(['1', '2', '3']),
                const SizedBox(height: 16),
                _buildKeyboardRow(['4', '5', '6']),
                const SizedBox(height: 16),
                _buildKeyboardRow(['7', '8', '9']),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: SizedBox()), // Empty cell
                    Expanded(
                      child: _buildKeyboardButton('0'),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.backspace_outlined, color: AppTheme.textPrimary, size: 24),
                        onPressed: _onBackspace,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return Expanded(
          child: _buildKeyboardButton(key),
        );
      }).toList(),
    );
  }

  Widget _buildKeyboardButton(String label) {
    return InkWell(
      onTap: () => _onKeyPress(label),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}
