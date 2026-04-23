import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/nutrition_cubit.dart';
import '../cubits/language_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/nutrition_model.dart';
import '../theme/app_theme.dart';
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
          backgroundColor: AppTheme.bgDark,
          appBar: AppBar(
            backgroundColor: AppTheme.bgDark,
            title: Text(l10n.translate('meals')),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => _showAddMealDialog(context, langState),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.emerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.emerald.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, size: 18, color: AppTheme.emerald),
                        SizedBox(width: 4),
                        Text('Add', style: TextStyle(color: AppTheme.emerald, fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _DailySummaryCard(today: today),
                    const SizedBox(height: 20),
                    ...MealType.values.map((type) {
                      final typeMeals = mealsByType[type] ?? [];
                      return _MealTypeSection(type: type, meals: typeMeals, isAr: isAr, onAdd: () => _showAddMealDialog(context, langState));
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

  void _showAddMealDialog(BuildContext context, LanguageState langState) {
    showDialog(
      context: context,
      builder: (ctx) => QuickAddFoodDialog(
        languageCode: langState.locale,
        onFoodAdded: (food) => context.read<NutritionCubit>().addMeal(food),
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  final DailyNutrition today;
  const _DailySummaryCard({required this.today});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4C35), Color(0xFF0B1D42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.emerald.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(label: 'Calories', value: '${today.caloriesConsumed}', unit: 'kcal', color: AppTheme.emerald),
              _Divider(),
              _SummaryItem(label: 'Meals', value: '${today.meals.length}', unit: 'logged', color: const Color(0xFF818CF8)),
              _Divider(),
              _SummaryItem(label: 'Water', value: (today.waterConsumedMl / 1000).toStringAsFixed(1), unit: 'liters', color: const Color(0xFF60A5FA)),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0x22FFFFFF), height: 0),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _MacroChip(label: 'Protein', value: today.proteinConsumed, color: const Color(0xFF60A5FA))),
              const SizedBox(width: 8),
              Expanded(child: _MacroChip(label: 'Carbs', value: today.carbsConsumed, color: AppTheme.emerald)),
              const SizedBox(width: 8),
              Expanded(child: _MacroChip(label: 'Fat', value: today.fatConsumed, color: const Color(0xFFFBBF24))),
            ],
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.15));
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  const _SummaryItem({required this.label, required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w800)),
        Text(unit, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _MacroChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text('${value.toStringAsFixed(0)}g', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _MealTypeSection extends StatelessWidget {
  final MealType type;
  final List<MealEntry> meals;
  final bool isAr;
  final VoidCallback onAdd;
  const _MealTypeSection({required this.type, required this.meals, required this.isAr, required this.onAdd});

  static const _mealIcons = {
    MealType.breakfast: Icons.wb_sunny_rounded,
    MealType.lunch: Icons.restaurant_rounded,
    MealType.dinner: Icons.nightlight_round,
    MealType.snack: Icons.cookie_rounded,
  };

  static const _mealColors = {
    MealType.breakfast: Color(0xFFFBBF24),
    MealType.lunch: Color(0xFF34D399),
    MealType.dinner: Color(0xFF818CF8),
    MealType.snack: Color(0xFFF87171),
  };

  String _typeName(bool isAr) {
    if (isAr) {
      return {
        MealType.breakfast: 'الإفطار',
        MealType.lunch: 'الغداء',
        MealType.dinner: 'العشاء',
        MealType.snack: 'وجبة خفيفة',
      }[type] ?? '';
    }
    return {
      MealType.breakfast: 'Breakfast',
      MealType.lunch: 'Lunch',
      MealType.dinner: 'Dinner',
      MealType.snack: 'Snacks',
    }[type] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final color = _mealColors[type] ?? AppTheme.emerald;
    final icon = _mealIcons[type] ?? Icons.restaurant_rounded;
    final totalCals = meals.fold<int>(0, (sum, m) => sum + m.calories);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(_typeName(isAr), style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
              if (meals.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('$totalCals kcal', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderDark)),
                  child: const Icon(Icons.add_rounded, size: 16, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (meals.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderDark),
              ),
              child: Text(
                'Tap + to log a meal',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            )
          else
            ...meals.map((meal) => _MealEntryCard(meal: meal, color: color)),
        ],
      ),
    );
  }
}

class _MealEntryCard extends StatelessWidget {
  final MealEntry meal;
  final Color color;
  const _MealEntryCard({required this.meal, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  'P ${meal.protein.toStringAsFixed(0)}g  •  C ${meal.carbs.toStringAsFixed(0)}g  •  F ${meal.fat.toStringAsFixed(0)}g',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${meal.calories}', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
              const Text('kcal', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
