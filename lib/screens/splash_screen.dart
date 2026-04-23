import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _progressController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  final List<IconData> _nutritionIcons = [
    Icons.restaurant,
    Icons.local_dining,
    Icons.water_drop,
    Icons.eco,
    Icons.apple,
    Icons.local_cafe,
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNext();
  }

  void _setupAnimations() {
    // Rotation animation
    _rotationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat();
    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotationController);

    // Fade animation
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Scale animation
    _scaleController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    // Progress animation
    _progressController = AnimationController(
        duration: const Duration(seconds: 2, milliseconds: 500), vsync: this);
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));

    _fadeController.forward();
    _scaleController.forward();
    _progressController.forward();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Force MainScreen for now since we mock a user in Cubit
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: Stack(
        children: [
          ...List.generate(20, (index) => _buildParticle(index)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: List.generate(_nutritionIcons.length, (index) {
                        final angle =
                            (2 * math.pi / _nutritionIcons.length) * index +
                                _rotationAnimation.value;
                        final radius = 80.0;
                        final x = math.cos(angle) * radius;
                        final y = math.sin(angle) * radius * 0.5;

                        return Transform.translate(
                          offset: Offset(x, y),
                          child: Transform.scale(
                            scale: (math.cos(angle) + 1.5) / 2.5,
                            child: Opacity(
                              opacity: (math.cos(angle) + 1.5) / 2.5,
                              child: Icon(
                                _nutritionIcons[index],
                                size: 40,
                                color: const Color(0xFF34D399),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 60),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'NutriTracker',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF34D399)
                                    .withValues(alpha: 0.5),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Nutrition Journey Starts Here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _progressAnimation.value,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF34D399),
                              ),
                              minHeight: 4,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 4 + 2;
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final top = random.nextDouble() * MediaQuery.of(context).size.height;
    final duration = random.nextInt(3) + 2;

    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Positioned(
          left: left,
          top: top,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.2, end: 1.0),
            duration: Duration(seconds: duration),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value * 0.5,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF34D399).withValues(alpha: 0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
