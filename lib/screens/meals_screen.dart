import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/nutrition_cubit.dart';
import '../cubits/language_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/nutrition_model.dart';
import '../widgets/quick_add_food_dialog.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final l10n = AppLocalizations(langState.locale);
        final isAr = langState.isArabic;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.translate('meals'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocBuilder<NutritionCubit, NutritionState>(
            builder: (context, nutritionState) {
              final today = nutritionState.today;
              final meals = today.meals;

              final mealsByType = <MealType, List<MealEntry>>{};
              for (final meal in meals) {
                mealsByType.putIfAbsent(meal.mealType, () => []).add(meal);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildDailySummary(context, today, l10n),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => QuickAddFoodDialog(
                              languageCode: langState.locale,
                              onFoodAdded: (food) {
                                context.read<NutritionCubit>().addMeal(food);
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: Text(l10n.translate('add_meal')),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...MealType.values.map((type) {
                      final typeMeals = mealsByType[type] ?? [];
                      return _buildMealTypeSection(
                          context, type, typeMeals, isAr);
                    }),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDailySummary(
      BuildContext context, DailyNutrition stats, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                  context,
                  Icons.local_fire_department,
                  stats.caloriesConsumed.toString(),
                  l10n.translate('calories')),
              _buildSummaryItem(context, Icons.restaurant_menu,
                  stats.meals.length.toString(), l10n.translate('meals')),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroItem(context, l10n.translate('protein'),
                  stats.proteinConsumed, Colors.blue),
              _buildMacroItem(context, l10n.translate('carbs'),
                  stats.carbsConsumed, Colors.green),
              _buildMacroItem(context, l10n.translate('fat'), stats.fatConsumed,
                  Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroItem(
      BuildContext context, String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}g',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildMealTypeSection(
      BuildContext context, MealType type, List<MealEntry> meals, bool isAr) {
    final mealTypeNames = {
      MealType.breakfast: isAr ? 'Ø§Ù„Ø¥ÙØ·Ø§Ø±' : 'Breakfast',
      MealType.lunch: isAr ? 'Ø§Ù„ØºØ¯Ø§Ø¡' : 'Lunch',
      MealType.dinner: isAr ? 'Ø§Ù„Ø¹Ø´Ø§Ø¡' : 'Dinner',
      MealType.snack: isAr ? 'ÙˆØ¬Ø¨Ø© Ø®ÙÙŠÙØ©' : 'Snack',
    };

    final totalCalories =
        meals.fold<int>(0, (sum, meal) => sum + meal.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealTypeNames[type] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (meals.isNotEmpty)
                Text(
                  '$totalCalories kcal',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ),
        if (meals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.05)),
            ),
            child: Text(
              isAr ? 'Ù„Ø§ ØªÙˆØ¬Ø¯ ÙˆØ¬Ø¨Ø§Øª' : 'No meals yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
          )
        else
          ...meals.map((meal) => _buildMealCard(context, meal, isAr)),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, MealEntry meal, bool isAr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  meal.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientInfo(context, Icons.local_fire_department,
                  '${meal.calories}', 'kcal', Colors.orange),
              _buildNutrientInfo(context, Icons.fitness_center,
                  '${meal.protein.toStringAsFixed(1)}g', 'P', Colors.blue),
              _buildNutrientInfo(context, Icons.bakery_dining,
                  '${meal.carbs.toStringAsFixed(1)}g', 'C', Colors.green),
              _buildNutrientInfo(context, Icons.water_drop,
                  '${meal.fat.toStringAsFixed(1)}g', 'F', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(BuildContext context, IconData icon, String value,
      String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
