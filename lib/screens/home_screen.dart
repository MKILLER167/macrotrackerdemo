import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user_cubit.dart';
import '../cubits/nutrition_cubit.dart';
import '../cubits/language_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/nutrition_model.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final l10n = AppLocalizations(langState.locale);
        return Scaffold(
          backgroundColor: AppTheme.bgDark,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context, l10n),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    _WelcomeCard(l10n: l10n),
                    const SizedBox(height: 20),
                    _CalorieRingCard(l10n: l10n),
                    const SizedBox(height: 20),
                    _MacroRowCard(l10n: l10n),
                    const SizedBox(height: 20),
                    _WaterCard(l10n: l10n),
                    const SizedBox(height: 20),
                    _RecentMealsSection(l10n: l10n),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppTheme.bgDark,
      title: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.emerald, AppTheme.indigo], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Text('NutriTracker', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppTheme.textPrimary)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language_rounded, color: AppTheme.textSecondary),
          onPressed: () => context.read<LanguageCubit>().toggleLanguage(),
        ),
        IconButton(
          icon: const Icon(Icons.brightness_medium_rounded, color: AppTheme.textSecondary),
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _WelcomeCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final profile = userState.user?.profile;
        final name = profile?.name ?? 'There';
        final plan = userState.activePlan?.nameEn ?? 'Standard Plan';

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.border2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good ${_greeting()} 👋',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(name, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.faint,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, size: 13, color: AppTheme.white),
                          const SizedBox(width: 5),
                          Text(plan, style: const TextStyle(color: AppTheme.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border2, width: 1.5),
                ),
                child: const Icon(Icons.person_rounded, color: AppTheme.white, size: 28),
              ),
            ],
          ),
        );
      },
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

class _CalorieRingCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _CalorieRingCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionCubit, NutritionState>(
      builder: (context, nsState) {
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final consumed = nsState.today.caloriesConsumed;
            final target = userState.user?.profile?.targetCalories ?? 2000;
            final remaining = (target - consumed).clamp(0, target);
            final progress = (consumed / target).clamp(0.0, 1.0);

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderDark),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.borderDark),
                        ),
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.emerald),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$consumed', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                            const Text('kcal', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily Calories', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('$target kcal goal', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        _StatChip(label: 'Consumed', value: '$consumed kcal', color: AppTheme.white),
                        const SizedBox(height: 8),
                        _StatChip(label: 'Remaining', value: '$remaining kcal', color: AppTheme.muted),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const Spacer(),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _MacroRowCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _MacroRowCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionCubit, NutritionState>(
      builder: (context, nsState) {
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final today = nsState.today;
            final target = userState.user?.profile?.targetCalories ?? 2000;
            final plan = userState.activePlan;
            final tProtein = target * (plan?.proteinRatio ?? 0.25) / 4;
            final tCarbs = target * (plan?.carbRatio ?? 0.5) / 4;
            final tFat = target * (plan?.fatRatio ?? 0.25) / 9;

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Macronutrients', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _MacroBar(label: 'Protein', consumed: today.proteinConsumed, target: tProtein, color: AppTheme.white)),
                      const SizedBox(width: 12),
                      Expanded(child: _MacroBar(label: 'Carbs', consumed: today.carbsConsumed, target: tCarbs, color: const Color(0xFFCCCCCC))),
                      const SizedBox(width: 12),
                      Expanded(child: _MacroBar(label: 'Fat', consumed: today.fatConsumed, target: tFat, color: const Color(0xFF999999))),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final Color color;
  const _MacroBar({required this.label, required this.consumed, required this.target, required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = target == 0 ? 0.0 : (consumed / target).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
            Text('${consumed.toStringAsFixed(0)}g', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text('/ ${target.toStringAsFixed(0)}g', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
      ],
    );
  }
}

class _WaterCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _WaterCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionCubit, NutritionState>(
      builder: (context, nsState) {
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final target = userState.user?.profile?.targetWaterMl ?? 3000;
            final consumed = nsState.today.waterConsumedMl;
            final glasses = (consumed / 250).floor();
            final targetGlasses = (target / 250).ceil();
            final progress = (consumed / target).clamp(0.0, 1.0);

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderDark),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.water_drop_rounded, color: AppTheme.muted, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Water Intake', style: TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                            Text('$glasses / $targetGlasses glasses', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text('${(consumed / 1000).toStringAsFixed(1)}L', style: const TextStyle(color: AppTheme.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: AppTheme.faint,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.read<NutritionCubit>().addWater(250),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border2),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded, color: AppTheme.white, size: 18),
                          SizedBox(width: 8),
                          Text('Add 250ml glass', style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _RecentMealsSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _RecentMealsSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionCubit, NutritionState>(
      builder: (context, state) {
        final meals = state.today.meals;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Meals', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                if (meals.isNotEmpty)
                  Text('${meals.length} logged', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 14),
            if (meals.isEmpty) _buildEmptyState() else ...meals.reversed.take(4).map((m) => _MealCard(meal: m)),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: const Column(
        children: [
          Icon(Icons.no_meals_rounded, size: 44, color: AppTheme.textSecondary),
          SizedBox(height: 12),
          Text('No meals logged yet', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
          SizedBox(height: 4),
          Text('Tap + to add your first meal', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealEntry meal;
  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.lunch_dining_rounded, color: AppTheme.muted, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  'P ${meal.protein.toStringAsFixed(0)}g  •  C ${meal.carbs.toStringAsFixed(0)}g  •  F ${meal.fat.toStringAsFixed(0)}g',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Text('${meal.calories}', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 17)),
          const Text(' kcal', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
