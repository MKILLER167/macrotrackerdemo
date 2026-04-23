import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation_cubit.dart';
import '../cubits/language_cubit.dart';
import '../l10n/app_localizations.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations(languageState.locale);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: BlocBuilder<NavigationCubit, int>(
                builder: (context, currentIndex) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        context,
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home,
                        label: l10n.translate('home'),
                        index: 0,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.restaurant_menu_outlined,
                        selectedIcon: Icons.restaurant_menu,
                        label: l10n.translate('meals'),
                        index: 1,
                        currentIndex: currentIndex,
                      ),
                      _buildCenterNavItem(context),
                      _buildNavItem(
                        context,
                        icon: Icons.menu_book_outlined,
                        selectedIcon: Icons.menu_book,
                        label: l10n.translate('guides'),
                        index: 2,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.person_outline,
                        selectedIcon: Icons.person,
                        label: l10n.translate('profile'),
                        index: 3,
                        currentIndex: currentIndex,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.read<NavigationCubit>().setIndex(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(isSelected ? 6 : 0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    color: isSelected
                        ? primaryColor
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected
                        ? primaryColor
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavItem(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 8,
        shadowColor: primaryColor.withValues(alpha: 0.4),
        child: InkWell(
          onTap: () {
            // Quick add meal
            context.read<NavigationCubit>().setIndex(1);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
