import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user_cubit.dart';
import '../cubits/nutrition_cubit.dart';
import '../cubits/language_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/nutrition_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final l10n = AppLocalizations(langState.locale);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildAppBar(context, l10n),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(context, l10n),
                const SizedBox(height: 24),
                _buildMacrosCard(context, l10n),
                const SizedBox(height: 24),
                _buildWaterTracker(context, l10n),
                const SizedBox(height: 24),
                _buildRecentMeals(context, l10n),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.translate('home'),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {
            context.read<LanguageCubit>().toggleLanguage();
          },
        ),
        IconButton(
          icon: const Icon(Icons.dark_mode_outlined),
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final user = userState.user?.profile;
        final name = user?.name ?? 'User';

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('welcome_back'),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            userState.activePlan?.nameEn ?? 'Standard Plan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.person, size: 30, color: Colors.white),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacrosCard(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<NutritionCubit, NutritionState>(
      builder: (context, nutritionState) {
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final today = nutritionState.today;
            final targetCalories =
                userState.user?.profile?.targetCalories ?? 2000;
            final activePlan = userState.activePlan;

            final targetProtein =
                targetCalories * (activePlan?.proteinRatio ?? 0.2) / 4;
            final targetCarbs =
                targetCalories * (activePlan?.carbRatio ?? 0.5) / 4;
            final targetFat =
                targetCalories * (activePlan?.fatRatio ?? 0.3) / 9;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.translate('calories'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${today.caloriesConsumed} / $targetCalories kcal',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (today.caloriesConsumed / targetCalories)
                            .clamp(0.0, 1.0),
                        minHeight: 12,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMacroRing(context, l10n.translate('protein'),
                            today.proteinConsumed, targetProtein, Colors.blue),
                        _buildMacroRing(context, l10n.translate('carbs'),
                            today.carbsConsumed, targetCarbs, Colors.green),
                        _buildMacroRing(context, l10n.translate('fat'),
                            today.fatConsumed, targetFat, Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMacroRing(BuildContext context, String label, double consumed,
      double target, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            value: (consumed / (target == 0 ? 1 : target)).clamp(0.0, 1.0),
            strokeWidth: 6,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          '${consumed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}g',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterTracker(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<NutritionCubit, NutritionState>(
      builder: (context, nutritionState) {
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final targetWater = userState.user?.profile?.targetWaterMl ?? 3000;
            final consumedWater = nutritionState.today.waterConsumedMl;

            return Card(
              child: InkWell(
                onTap: () {
                  context
                      .read<NutritionCubit>()
                      .addWater(250); // Add 250ml glass
                },
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.water_drop,
                            color: Colors.blue, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.translate('water_intake'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '$consumedWater / $targetWater ml',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: const IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: null, // Tap handled by InkWell
                        ),
                      )
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

  Widget _buildRecentMeals(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<NutritionCubit, NutritionState>(
      builder: (context, state) {
        final meals = state.today.meals;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('recent_meals'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            if (meals.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.translate('no_meals'),
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...meals.reversed
                  .take(3)
                  .map((meal) => _buildMealRow(context, meal)),
          ],
        );
      },
    );
  }

  Widget _buildMealRow(BuildContext context, MealEntry meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.fastfood,
                color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${meal.calories} kcal â€¢ P: ${meal.protein.toStringAsFixed(0)}g',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
