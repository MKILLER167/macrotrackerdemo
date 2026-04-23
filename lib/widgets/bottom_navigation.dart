import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation_cubit.dart';
import '../cubits/language_cubit.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations(languageState.locale);
        return BlocBuilder<NavigationCubit, int>(
          builder: (context, currentIndex) {
            return Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: const Border(
                  top: BorderSide(color: AppTheme.border, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: l10n.translate('home'), index: 0, currentIndex: currentIndex),
                      _NavItem(icon: Icons.restaurant_menu_outlined, selectedIcon: Icons.restaurant_menu, label: l10n.translate('meals'), index: 1, currentIndex: currentIndex),
                      _CenterAddButton(),
                      _NavItem(icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, label: l10n.translate('guides'), index: 2, currentIndex: currentIndex),
                      _NavItem(icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded, label: l10n.translate('profile'), index: 3, currentIndex: currentIndex),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int currentIndex;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<NavigationCubit>().setIndex(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.mint.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                size: 24,
                color: isSelected ? AppTheme.mint : AppTheme.muted,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppTheme.mint : AppTheme.muted,
              ),
              child: Text(label, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterAddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => context.read<NavigationCubit>().setIndex(1),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.mint, AppTheme.violet],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: AppTheme.mint.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
