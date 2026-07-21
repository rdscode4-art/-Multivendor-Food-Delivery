import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'login_screen.dart';
import 'main_container.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _slideTimer;

  final List<Map<String, String>> _onboardingSlides = [
    {
      'title': 'Fastest Delivery',
      'desc': 'Get your favourite hot meals delivered to your doorstep in under 30 minutes.',
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
    },
    {
      'title': 'Fresh & Tasty',
      'desc': 'We partner only with premium restaurants to ensure every meal is freshly prepared.',
      'image': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600',
    },
    {
      'title': 'Secure Payments',
      'desc': 'Pay instantly with credit cards, UPI, wallets, or choose cash on delivery.',
      'image': 'https://images.unsplash.com/photo-1559715745-e1b33a271c8f?w=600',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll slides every 3 seconds
    _slideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _onboardingSlides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Sliding Hero Background Image PageView (Filling Entire Screen)
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _onboardingSlides.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      _onboardingSlides[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                    // Dark visual gradient overlay (makes sure text is highly readable)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.75),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 2. Creative Logo Header
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                  ),
                  child: Row(
                    children: const [
                      Text('🍔', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Text(
                        'Foodies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Main Onboarding Frosted Glass Container (Floating Card)
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Text details synchronized with slides
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          key: ValueKey<int>(_currentPage),
                          children: [
                            Text(
                              _onboardingSlides[_currentPage]['title']!,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _onboardingSlides[_currentPage]['desc']!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      
                      // Animated Slide Dot Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_onboardingSlides.length, (index) {
                          final isActive = _currentPage == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isActive ? 18 : 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isActive ? AppTheme.orange : AppTheme.textMuted,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      // Actions: Start with Email (black/navy)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.navy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Start with email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Continue with Social platforms
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                AppStateProvider.of(context, listen: false).login('facebook@user.com', 'Facebook Guest');
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MainContainer()),
                                  (route) => false,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.grey.shade400, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.facebook, color: Colors.blue, size: 18),
                                  SizedBox(width: 6),
                                  Text('Facebook', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textPrimary)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                AppStateProvider.of(context, listen: false).login('google@user.com', 'Google Guest');
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MainContainer()),
                                  (route) => false,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.grey.shade400, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('G', style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 6),
                                  Text('Google', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textPrimary)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Already have an account? Sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: AppTheme.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
