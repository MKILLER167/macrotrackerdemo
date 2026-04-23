import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user_cubit.dart';
import '../cubits/language_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            title: Text(l10n.translate('profile')),
          ),
          body: BlocBuilder<UserCubit, UserState>(
            builder: (context, userState) {
              final user = userState.user;
              final stats = userState.stats;
              if (user == null || user.profile == null) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.emerald));
              }
              final profile = user.profile!;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _ProfileHeader(profile: profile),
                    const SizedBox(height: 20),
                    _StatsRow(stats: stats),
                    const SizedBox(height: 20),
                    _NutritionGoalsCard(profile: profile, isAr: isAr, userState: userState, l10n: l10n),
                    const SizedBox(height: 16),
                    _BodyMetricsCard(profile: profile, isAr: isAr),
                    const SizedBox(height: 16),
                    _SettingsCard(l10n: l10n, isAr: isAr),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88, height: 88,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppTheme.emerald, AppTheme.indigo], begin: Alignment.topLeft, end: Alignment.bottomRight),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppTheme.emerald.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: const Icon(Icons.person_rounded, size: 44, color: Colors.white),
        ),
        const SizedBox(height: 14),
        Text(profile.name, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text(
          '${profile.weight.toStringAsFixed(0)} kg  •  ${profile.height.toStringAsFixed(0)} cm  •  Age ${profile.age}',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final dynamic stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatBox(icon: Icons.local_fire_department_rounded, value: '${stats?.streakDays ?? 0}', label: 'Day Streak', color: const Color(0xFFFB923C))),
        const SizedBox(width: 12),
        Expanded(child: _StatBox(icon: Icons.restaurant_rounded, value: '${stats?.totalMealsLogged ?? 0}', label: 'Meals Logged', color: AppTheme.emerald)),
        const SizedBox(width: 12),
        Expanded(child: _StatBox(icon: Icons.emoji_events_rounded, value: 'Lv${stats?.level ?? 1}', label: 'Level', color: const Color(0xFFA78BFA))),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatBox({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _NutritionGoalsCard extends StatelessWidget {
  final UserProfile profile;
  final bool isAr;
  final UserState userState;
  final AppLocalizations l10n;
  const _NutritionGoalsCard({required this.profile, required this.isAr, required this.userState, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final goalLabel = {
      GoalType.loseWeight: isAr ? 'خسارة الوزن' : 'Lose Weight',
      GoalType.maintain: isAr ? 'المحافظة على الوزن' : 'Maintain',
      GoalType.gainMuscle: isAr ? 'بناء العضلات' : 'Gain Muscle',
    }[profile.goal] ?? 'Maintain';

    final activityLabel = {
      ActivityLevel.sedentary: 'Sedentary',
      ActivityLevel.lightlyActive: 'Lightly Active',
      ActivityLevel.moderatelyActive: 'Moderately Active',
      ActivityLevel.veryActive: 'Very Active',
      ActivityLevel.extraActive: 'Extra Active',
    }[profile.activityLevel] ?? 'Moderate';

    return _InfoCard(
      title: isAr ? 'أهداف التغذية' : 'Nutrition Goals',
      children: [
        _InfoRow(label: isAr ? 'الهدف' : 'Goal', value: goalLabel, valueColor: AppTheme.emerald),
        _InfoRow(label: isAr ? 'السعرات المستهدفة' : 'Target Calories', value: '${profile.targetCalories} kcal'),
        _InfoRow(label: isAr ? 'الوزن المستهدف' : 'Target Weight', value: '${profile.targetWeight.toStringAsFixed(1)} kg'),
        _InfoRow(label: isAr ? 'مستوى النشاط' : 'Activity', value: activityLabel),
        _InfoRow(label: isAr ? 'الماء المستهدف' : 'Water Goal', value: '${(profile.targetWaterMl / 1000).toStringAsFixed(1)} L'),
        _InfoRow(label: isAr ? 'الخطة الغذائية' : 'Diet Plan', value: isAr ? (userState.activePlan?.nameAr ?? '') : (userState.activePlan?.nameEn ?? ''), isLast: true),
      ],
    );
  }
}

class _BodyMetricsCard extends StatelessWidget {
  final UserProfile profile;
  final bool isAr;
  const _BodyMetricsCard({required this.profile, required this.isAr});

  double get _bmi => profile.weight / ((profile.height / 100) * (profile.height / 100));
  String get _bmiCategory {
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Normal';
    if (_bmi < 30) return 'Overweight';
    return 'Obese';
  }
  Color get _bmiColor {
    if (_bmi < 18.5) return const Color(0xFF60A5FA);
    if (_bmi < 25) return AppTheme.emerald;
    if (_bmi < 30) return const Color(0xFFFBBF24);
    return const Color(0xFFF87171);
  }

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: isAr ? 'المقاييس الجسدية' : 'Body Metrics',
      children: [
        _InfoRow(label: isAr ? 'الوزن الحالي' : 'Current Weight', value: '${profile.weight.toStringAsFixed(1)} kg'),
        _InfoRow(label: isAr ? 'الطول' : 'Height', value: '${profile.height.toStringAsFixed(0)} cm'),
        _InfoRow(label: isAr ? 'العمر' : 'Age', value: '${profile.age} years'),
        _InfoRow(label: 'BMI', value: '${_bmi.toStringAsFixed(1)} – $_bmiCategory', valueColor: _bmiColor, isLast: true),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isAr;
  const _SettingsCard({required this.l10n, required this.isAr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: AppTheme.indigo.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.language_rounded, color: AppTheme.indigoLight, size: 20),
            ),
            title: Text(isAr ? 'اللغة' : 'Language', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
            subtitle: Text(isAr ? 'التبديل إلى الإنجليزية' : 'Toggle Arabic / English', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
            onTap: () => context.read<LanguageCubit>().toggleLanguage(),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
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
          Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;
  const _InfoRow({required this.label, required this.value, this.valueColor, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              Text(value, style: TextStyle(color: valueColor ?? AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        if (!isLast) const Divider(color: AppTheme.borderDark, height: 0),
      ],
    );
  }
}
