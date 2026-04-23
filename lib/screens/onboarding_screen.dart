import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'questionnaire_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _pages = [
    _OPage(
      gradient: [Color(0xFF141414), Color(0xFF0A0A0A)],
      glow: AppTheme.white,
      icon: Icons.restaurant_menu_rounded,
      tag: 'TRACK FOOD',
      title: 'Log every\nbite, instantly',
      body: 'Search millions of foods or scan a barcode to track calories and macros in seconds.',
    ),
    _OPage(
      gradient: [Color(0xFF111111), Color(0xFF0A0A0A)],
      glow: Color(0xFFCCCCCC),
      icon: Icons.water_drop_rounded,
      tag: 'STAY HYDRATED',
      title: 'Hit your water\ngoal daily',
      body: 'Smart reminders and one-tap glass logging keep you perfectly hydrated all day long.',
    ),
    _OPage(
      gradient: [Color(0xFF0E0E0E), Color(0xFF0A0A0A)],
      glow: Color(0xFFAAAAAA),
      icon: Icons.insights_rounded,
      tag: 'SEE PROGRESS',
      title: 'Watch your\nbody transform',
      body: 'Beautiful charts reveal how close you are to hitting your personalized goal weight.',
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _ctrl.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic);
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const QuestionnaireScreen(),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // Background gradient changes per page
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _pages[_page].gradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Skip
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _next,
                    child: const Text('Skip', style: TextStyle(color: AppTheme.muted, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _ctrl,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemCount: _pages.length,
                    itemBuilder: (_, i) => _PageContent(page: _pages[i]),
                  ),
                ),
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) => _Dot(active: i == _page, color: _pages[_page].glow)),
                ),
                const SizedBox(height: 32),
                // CTA button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity, height: 58,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [_pages[_page].glow, AppTheme.violet], begin: Alignment.centerLeft, end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: _pages[_page].glow.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 6))],
                      ),
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: Text(
                          _page == _pages.length - 1 ? 'Build My Plan →' : 'Next →',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OPage {
  final List<Color> gradient;
  final Color glow;
  final IconData icon;
  final String tag;
  final String title;
  final String body;
  const _OPage({required this.gradient, required this.glow, required this.icon, required this.tag, required this.title, required this.body});
}

class _PageContent extends StatelessWidget {
  final _OPage page;
  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Glowing icon
          Container(
            width: 96, height: 96,
            decoration: BoxDecoration(
              color: page.glow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: page.glow.withValues(alpha: 0.3), width: 1.5),
              boxShadow: [BoxShadow(color: page.glow.withValues(alpha: 0.25), blurRadius: 32, spreadRadius: 4)],
            ),
            child: Icon(page.icon, size: 48, color: page.glow),
          ),
          const SizedBox(height: 36),
          // Tag pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: page.glow.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: page.glow.withValues(alpha: 0.3)),
            ),
            child: Text(page.tag, style: TextStyle(color: page.glow, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          ),
          const SizedBox(height: 16),
          Text(page.title, style: const TextStyle(color: AppTheme.white, fontSize: 36, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.8)),
          const SizedBox(height: 18),
          Text(page.body, style: const TextStyle(color: AppTheme.muted, fontSize: 16, height: 1.6)),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  final Color color;
  const _Dot({required this.active, required this.color});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 22 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? color : AppTheme.faint,
        borderRadius: BorderRadius.circular(3),
        boxShadow: active ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6)] : null,
      ),
    );
  }
}
