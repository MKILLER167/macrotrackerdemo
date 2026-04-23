import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _orbit  = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  late final AnimationController _enter  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  late final AnimationController _bar    = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
  late final Animation<double> _fadeIn   = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
  late final Animation<double> _scaleIn  = Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _enter, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    _enter.forward();
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const MainScreen(),
          transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _orbit.dispose();
    _enter.dispose();
    _bar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // radial glow behind logo
          Positioned(
            top: size.height * 0.28,
            left: size.width / 2 - 120,
            child: Container(
              width: 240, height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.mint.withValues(alpha: 0.18),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          // orbit ring
          Center(
            child: AnimatedBuilder(
              animation: _orbit,
              builder: (_, __) {
                return SizedBox(
                  width: 200, height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(6, (i) {
                      final angle = (math.pi * 2 / 6) * i + _orbit.value * math.pi * 2;
                      return Transform.translate(
                        offset: Offset(math.cos(angle) * 88, math.sin(angle) * 88),
                        child: Opacity(
                          opacity: ((math.cos(angle) + 1) / 2).clamp(0.25, 1.0),
                          child: Container(
                            width: 10, height: 10,
                            decoration: BoxDecoration(
                              color: AppTheme.mint,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: AppTheme.mint.withValues(alpha: 0.6), blurRadius: 8, spreadRadius: 1)],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          // logo + text
          Center(
            child: ScaleTransition(
              scale: _scaleIn,
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon box
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppTheme.mint, AppTheme.violet], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: AppTheme.mint.withValues(alpha: 0.5), blurRadius: 28, spreadRadius: 2),
                          BoxShadow(color: AppTheme.violet.withValues(alpha: 0.3), blurRadius: 48, spreadRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.eco_rounded, color: Colors.black, size: 42),
                    ),
                    const SizedBox(height: 28),
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(colors: [AppTheme.mint, AppTheme.lilac]).createShader(b),
                      child: const Text(
                        'NutriTracker',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your science-based nutrition engine',
                      style: TextStyle(color: AppTheme.muted, fontSize: 14, letterSpacing: 0.2),
                    ),
                    const SizedBox(height: 52),
                    // Progress bar
                    AnimatedBuilder(
                      animation: _bar,
                      builder: (_, __) => SizedBox(
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _bar.value,
                            minHeight: 3,
                            backgroundColor: AppTheme.faint,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.mint),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // bottom version tag
          Positioned(
            bottom: 32, left: 0, right: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: const Text('v1.0  •  Powered by Mifflin-St Jeor', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.faint, fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }
}
