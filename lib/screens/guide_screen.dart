import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/language_cubit.dart';
import '../cubits/user_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/diet_plan.dart';
import '../theme/app_theme.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

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
            title: Text(l10n.translate('nutrition_guide')),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: isAr ? 'اختر خطتك الغذائية' : 'Choose Your Diet Plan'),
                const SizedBox(height: 16),
                _DietPlanSelector(isAr: isAr),
                const SizedBox(height: 28),
                _SectionHeader(title: isAr ? 'نصائح التغذية' : 'Nutrition Tips'),
                                _TipCard(
                  icon: Icons.water_drop_rounded,
                  color: AppTheme.white,
                  title: isAr ? 'اشرب الماء قبل الوجبات' : 'Drink Water Before Meals',
                  desc: isAr
                      ? 'يساعد شرب كوب من الماء قبل الوجبات على الهضم والشعور بالشبع بشكل أسرع.'
                      : 'Drinking a glass of water 30min before meals improves digestion and promotes fullness.',
                ),
                _TipCard(
                  icon: Icons.wb_sunny_rounded,
                  color: const Color(0xFFCCCCCC),
                  title: isAr ? 'لا تفوت وجبة الإفطار' : 'Don\'t Skip Breakfast',
                  desc: isAr
                      ? 'الإفطار الصحي يمنحك الطاقة لبدء يومك بشكل صحيح.'
                      : 'A healthy breakfast kickstarts metabolism and reduces sugar cravings throughout the day.',
                ),
                _TipCard(
                  icon: Icons.restaurant_rounded,
                  color: const Color(0xFFAAAAAA),
                  title: isAr ? 'التحكم في الحصص الغذائية' : 'Portion Control',
                  desc: isAr
                      ? 'استخدم أطباقاً أصغر حجماً لتجنب الإفراط في تناول الطعام.'
                      : 'Use smaller plates and eat slowly — your brain takes 20 minutes to register fullness.',
                ),
                _TipCard(
                  icon: Icons.fitness_center_rounded,
                  color: const Color(0xFF888888),
                  title: isAr ? 'البروتين مع كل وجبة' : 'Protein With Every Meal',
                  desc: isAr
                      ? 'البروتين يساعد على الشعور بالشبع لفترة أطول ودعم بناء العضلات.'
                      : 'Including protein in each meal promotes satiety, muscle maintenance, and metabolic health.',
                ),
                _TipCard(
                  icon: Icons.nightlight_round,
                  color: const Color(0xFF666666),
                  title: isAr ? 'تجنب الأكل المتأخر' : 'Avoid Late Night Eating',
                  desc: isAr
                      ? 'تناول الطعام قبل النوم بساعتين على الأقل يحسن جودة النوم والهضم.'
                      : 'Eating at least 2 hours before bed improves sleep quality and promotes better digestion.',
                ),�ب الأكل المتأخر' : 'Avoid Late Night Eating',
                  desc: isAr
                      ? 'تناول الطعام قبل النوم بساعتين على الأقل يحسن جودة النوم والهضم.'
                      : 'Eating at least 2 hours before bed improves sleep quality and promotes better digestion.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 22, decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _DietPlanSelector extends StatelessWidget {
  final bool isAr;
  const _DietPlanSelector({required this.isAr});

  static const List<IconData> _planIcons = [
    Icons.balance_rounded,
    Icons.local_fire_department_rounded,
    Icons.timer_rounded,
    Icons.fitness_center_rounded,
    Icons.eco_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final plans = DietPlanService.standardPlans;
        final activePlanType = userState.user?.profile?.dietPlan;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: plans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final plan = plans[index];
            final isActive = plan.type == activePlanType;
            final icon = index < _planIcons.length ? _planIcons[index] : Icons.restaurant_rounded;

            return GestureDetector(
              onTap: () => context.read<UserCubit>().updateDietPlan(plan.type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive ? AppTheme.emerald.withValues(alpha: 0.1) : AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive ? AppTheme.emerald : AppTheme.borderDark,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: isActive ? AppTheme.emerald.withValues(alpha: 0.2) : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: isActive ? AppTheme.emerald : AppTheme.textSecondary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? plan.nameAr : plan.nameEn,
                            style: TextStyle(color: isActive ? AppTheme.emerald : AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isAr ? plan.descAr : plan.descEn,
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isActive)
                      Container(
                        width: 24, height: 24,
                        decoration: const BoxDecoration(color: AppTheme.emerald, shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                      )
                    else
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(border: Border.all(color: AppTheme.borderDark, width: 1.5), shape: BoxShape.circle),
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
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  const _TipCard({required this.icon, required this.color, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
