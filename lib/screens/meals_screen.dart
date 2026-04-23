import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../cubits/nutrition_cubit.dart';
import '../cubits/language_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/nutrition_model.dart';
import '../theme/app_theme.dart';
import '../widgets/quick_add_food_dialog.dart';

// ── Color system for meal types (monochromatic) ───────────────────────────────
const _mealColors = {
  MealType.breakfast: Color(0xFFFFFFFF),   // white
  MealType.lunch:     Color(0xFFCCCCCC),   // light grey
  MealType.dinner:    Color(0xFF999999),   // mid grey
  MealType.snack:     Color(0xFFAAAAAA),   // soft grey
};

const _mealIcons = {
  MealType.breakfast: Icons.wb_sunny_rounded,
  MealType.lunch:     Icons.restaurant_rounded,
  MealType.dinner:    Icons.nightlight_round,
  MealType.snack:     Icons.cookie_rounded,
};

// ── Main screen ────────────────────────────────────────────────────────────────
class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});
  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final l10n = AppLocalizations(langState.locale);
        return Scaffold(
          backgroundColor: AppTheme.bg,
          extendBodyBehindAppBar: false,
          appBar: _buildAppBar(context, l10n, langState),
          body: TabBarView(
            controller: _tabs,
            physics: const BouncingScrollPhysics(),
            children: [
              _MealLogTab(langState: langState),
              _ComingSoonTab(label: 'Custom Meals', icon: Icons.bookmark_add_outlined),
              _ComingSoonTab(label: 'Search Foods', icon: Icons.search_rounded),
              _ComingSoonTab(label: 'Insights', icon: Icons.bar_chart_rounded),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext ctx, AppLocalizations l10n, LanguageState langState) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(106),
      child: Container(
        color: AppTheme.bg,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate('meals'),
                            style: const TextStyle(color: AppTheme.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                          ),
                          Text(
                            'Today • ${DateTime.now().day} ${_month(DateTime.now().month)}',
                            style: const TextStyle(color: AppTheme.muted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    _AddButton(onTap: () => _showAdd(ctx, langState)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TabBar(
                controller: _tabs,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                labelPadding: const EdgeInsets.symmetric(horizontal: 14),
                indicatorColor: AppTheme.mint,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppTheme.mint,
                unselectedLabelColor: AppTheme.muted,
                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                dividerColor: AppTheme.border,
                splashFactory: NoSplash.splashFactory,
                tabs: const [
                  Tab(text: 'Meal Log'),
                  Tab(text: 'Custom Meals'),
                  Tab(text: 'Add Food'),
                  Tab(text: 'Insights'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdd(BuildContext context, LanguageState langState) {
    showDialog(
      context: context,
      builder: (ctx) => QuickAddFoodDialog(
        languageCode: langState.locale,
        onFoodAdded: (food) => context.read<NutritionCubit>().addMeal(food),
      ),
    );
  }

  String _month(int m) => const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m];
}

// ── Add button ─────────────────────────────────────────────────────────────────
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border2),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 18, color: AppTheme.white),
            SizedBox(width: 4),
            Text('Log Food', style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w800, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ── Meal Log Tab ───────────────────────────────────────────────────────────────
class _MealLogTab extends StatelessWidget {
  final LanguageState langState;
  const _MealLogTab({required this.langState});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionCubit, NutritionState>(
      builder: (context, nsState) {
        final today = nsState.today;
        final meals = today.meals;
        final byType = <MealType, List<MealEntry>>{};
        for (final m in meals) { byType.putIfAbsent(m.mealType, () => []).add(m); }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _CalorieRingCard(today: today),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final type = MealType.values[i];
                    final typeMeals = byType[type] ?? [];
                    return _MealSection(
                      type: type,
                      meals: typeMeals,
                      isAr: langState.isArabic,
                      onAdd: () {
                        showDialog(
                          context: context,
                          builder: (_) => QuickAddFoodDialog(
                            languageCode: langState.locale,
                            onFoodAdded: (food) => context.read<NutritionCubit>().addMeal(food),
                          ),
                        );
                      },
                    );
                  },
                  childCount: MealType.values.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Calorie ring summary ───────────────────────────────────────────────────────
class _CalorieRingCard extends StatelessWidget {
  final DailyNutrition today;
  const _CalorieRingCard({required this.today});

  static const _target = 2000; // fallback

  @override
  Widget build(BuildContext context) {
    final progress = (today.caloriesConsumed / _target).clamp(0.0, 1.0);
    final remaining = (_target - today.caloriesConsumed).clamp(0, _target);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Donut chart
              SizedBox(
                width: 110, height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        startDegreeOffset: -90,
                        sectionsSpace: 0,
                        centerSpaceRadius: 38,
                        sections: [
                          PieChartSectionData(
                            value: progress * 100,
                            color: AppTheme.mint,
                            radius: 14,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: (1 - progress) * 100,
                            color: AppTheme.faint,
                            radius: 14,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${today.caloriesConsumed}',
                          style: const TextStyle(color: AppTheme.white, fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        const Text('kcal', style: TextStyle(color: AppTheme.muted, fontSize: 10, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatRow(dot: AppTheme.white, label: 'Eaten', value: '${today.caloriesConsumed} kcal'),
                    const SizedBox(height: 10),
                    _StatRow(dot: AppTheme.muted, label: 'Remaining', value: '$remaining kcal'),
                    const SizedBox(height: 10),
                    _StatRow(dot: AppTheme.faint, label: 'Goal', value: '$_target kcal'),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: AppTheme.faint,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.mint),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.border, height: 0),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _MacroBar(label: 'Protein', g: today.proteinConsumed, target: 150, color: AppTheme.white)),
              const SizedBox(width: 10),
              Expanded(child: _MacroBar(label: 'Carbs',   g: today.carbsConsumed,   target: 250, color: const Color(0xFFCCCCCC))),
              const SizedBox(width: 10),
              Expanded(child: _MacroBar(label: 'Fat',     g: today.fatConsumed,     target:  65, color: const Color(0xFF999999))),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final Color dot;
  final String label;
  final String value;
  const _StatRow({required this.dot, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
      const Spacer(),
      Text(value, style: const TextStyle(color: AppTheme.white, fontSize: 12, fontWeight: FontWeight.w700)),
    ],
  );
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double g;
  final double target;
  final Color color;
  const _MacroBar({required this.label, required this.g, required this.target, required this.color});
  @override
  Widget build(BuildContext context) {
    final pct = (g / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 11, fontWeight: FontWeight.w600)),
            Text('${g.toStringAsFixed(0)}g', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 2),
        Text('/ ${target.toStringAsFixed(0)}g', style: const TextStyle(color: AppTheme.muted, fontSize: 9)),
      ],
    );
  }
}

// ── Meal section ───────────────────────────────────────────────────────────────
class _MealSection extends StatelessWidget {
  final MealType type;
  final List<MealEntry> meals;
  final bool isAr;
  final VoidCallback onAdd;
  const _MealSection({required this.type, required this.meals, required this.isAr, required this.onAdd});

  String get _name => isAr
    ? {MealType.breakfast: 'الإفطار', MealType.lunch: 'الغداء', MealType.dinner: 'العشاء', MealType.snack: 'وجبة خفيفة'}[type]!
    : {MealType.breakfast: 'Breakfast', MealType.lunch: 'Lunch', MealType.dinner: 'Dinner', MealType.snack: 'Snacks'}[type]!;

  @override
  Widget build(BuildContext context) {
    final color = _mealColors[type] ?? AppTheme.mint;
    final icon  = _mealIcons[type] ?? Icons.restaurant_rounded;
    final totalCals = meals.fold<int>(0, (s, m) => s + m.calories);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 0),
              child: Row(
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, color: color, size: 19),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800)),
                        Text(
                          meals.isEmpty ? 'Nothing logged yet' : '${meals.length} item${meals.length == 1 ? '' : 's'}',
                          style: const TextStyle(color: AppTheme.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  if (meals.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.25))),
                      child: Text('$totalCals kcal', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                  const SizedBox(width: 8),
                  // Add button
                  GestureDetector(
                    onTap: onAdd,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: Icon(Icons.add_rounded, size: 18, color: color),
                    ),
                  ),
                ],
              ),
            ),
            // ── Divider ──
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Divider(height: 0, color: AppTheme.border),
            ),
            // ── Meal entries or empty ──
            meals.isEmpty
              ? _EmptyState(color: color, name: _name, onAdd: onAdd)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  itemCount: meals.length,
                  separatorBuilder: (_, __) => Divider(height: 12, color: AppTheme.border),
                  itemBuilder: (_, i) => _EntryRow(meal: meals[i], color: color),
                ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final Color color;
  final String name;
  final VoidCallback onAdd;
  const _EmptyState({required this.color, required this.name, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: Icon(Icons.add_circle_outline_rounded, color: color.withValues(alpha: 0.5), size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            'No $name logged yet',
            style: const TextStyle(color: AppTheme.muted, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onAdd,
            child: Text(
              'Add $name →',
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single entry row ───────────────────────────────────────────────────────────
class _EntryRow extends StatelessWidget {
  final MealEntry meal;
  final Color color;
  const _EntryRow({required this.meal, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.name, style: const TextStyle(color: AppTheme.white, fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(
                  'P ${meal.protein.toStringAsFixed(0)}g  C ${meal.carbs.toStringAsFixed(0)}g  F ${meal.fat.toStringAsFixed(0)}g',
                  style: const TextStyle(color: AppTheme.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${meal.calories} kcal',
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Coming Soon tab placeholder ───────────────────────────────────────────────
class _ComingSoonTab extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ComingSoonTab({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.mint, AppTheme.violet], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: AppTheme.mint.withValues(alpha: 0.35), blurRadius: 20)],
            ),
            child: Icon(icon, color: Colors.black, size: 34),
          ),
          const SizedBox(height: 20),
          Text(label, style: const TextStyle(color: AppTheme.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Coming soon', style: TextStyle(color: AppTheme.muted, fontSize: 14)),
        ],
      ),
    );
  }
}
