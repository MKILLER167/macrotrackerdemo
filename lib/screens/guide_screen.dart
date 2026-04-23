import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/language_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/diet_plan.dart';
import '../cubits/user_cubit.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final l10n = AppLocalizations(langState.locale);
        final isAr = langState.isArabic;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.translate('nutrition_guide'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, l10n.translate('diet_plan')),
                const SizedBox(height: 16),
                _buildDietPlansSelector(context, isAr),
                const SizedBox(height: 32),
                _buildSectionTitle(context, l10n.translate('tips_tricks')),
                const SizedBox(height: 16),
                _buildTipCard(
                  context,
                  icon: Icons.water_drop,
                  color: Colors.blue,
                  title: isAr
                      ? 'Ø§Ø´Ø±Ø¨ Ø§Ù„Ù…Ø§Ø¡ Ù‚Ø¨Ù„ Ø§Ù„ÙˆØ¬Ø¨Ø§Øª'
                      : 'Drink Water Before Meals',
                  desc: isAr
                      ? 'ÙŠØ³Ø§Ø¹Ø¯ Ø´Ø±Ø¨ ÙƒÙˆØ¨ Ù…Ù† Ø§Ù„Ù…Ø§Ø¡ Ù‚Ø¨Ù„ Ø§Ù„ÙˆØ¬Ø¨Ø§Øª Ø¹Ù„Ù‰ Ø§Ù„Ù‡Ø¶Ù… ÙˆØ§Ù„Ø´Ø¹ÙˆØ± Ø¨Ø§Ù„Ø´Ø¨Ø¹.'
                      : 'Drinking a glass of water before meals helps digestion and promotes fullness.',
                ),
                _buildTipCard(
                  context,
                  icon: Icons.access_time,
                  color: Colors.purple,
                  title: isAr
                      ? 'Ù„Ø§ ØªÙÙˆØª ÙˆØ¬Ø¨Ø© Ø§Ù„Ø¥ÙØ·Ø§Ø±'
                      : 'Don\'t Skip Breakfast',
                  desc: isAr
                      ? 'Ø§Ù„Ø¥ÙØ·Ø§Ø± Ø§Ù„ØµØ­ÙŠ ÙŠÙ…Ù†Ø­Ùƒ Ø§Ù„Ø·Ø§Ù‚Ø© Ù„Ø¨Ø¯Ø¡ ÙŠÙˆÙ…Ùƒ Ø¨Ø´ÙƒÙ„ ØµØ­ÙŠØ­ ÙˆÙŠÙ‚Ù„Ù„ Ù…Ù† Ø§Ù„Ø±ØºØ¨Ø© ÙÙŠ ØªÙ†Ø§ÙˆÙ„ Ø§Ù„Ø³ÙƒØ±.'
                      : 'A healthy breakfast kickstarts your metabolism and reduces sugar cravings.',
                ),
                _buildTipCard(
                  context,
                  icon: Icons.restaurant,
                  color: Colors.green,
                  title: isAr
                      ? 'Ø§Ù„ØªØ­ÙƒÙ… ÙÙŠ Ø§Ù„Ø­ØµØµ Ø§Ù„ØºØ°Ø§Ø¦ÙŠØ©'
                      : 'Portion Control',
                  desc: isAr
                      ? 'Ø§Ø³ØªØ®Ø¯Ù… Ø£Ø·Ø¨Ø§Ù‚Ù‹Ø§ Ø£ØµØºØ± Ø­Ø¬Ù…Ù‹Ø§ Ù„ØªØ¬Ù†Ø¨ Ø§Ù„Ø¥ÙØ±Ø§Ø· ÙÙŠ ØªÙ†Ø§ÙˆÙ„ Ø§Ù„Ø·Ø¹Ø§Ù… Ø­ØªÙ‰ Ø¹Ù†Ø¯ ØªÙ†Ø§ÙˆÙ„ Ø§Ù„Ø£Ø·Ø¹Ù…Ø© Ø§Ù„ØµØ­ÙŠØ©.'
                      : 'Use smaller plates to avoid overeating even when eating healthy foods.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDietPlansSelector(BuildContext context, bool isAr) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final plans = DietPlanService.standardPlans;
        final activePlanType = userState.user?.profile?.dietPlan;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: plans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final plan = plans[index];
            final isActive = plan.type == activePlanType;

            return InkWell(
              onTap: () {
                context.read<UserCubit>().updateDietPlan(plan.type);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1)
                      : Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.05),
                    width: isActive ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_border,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? plan.nameAr : plan.nameEn,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr ? plan.descAr : plan.descEn,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isActive)
                      Icon(Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTipCard(BuildContext context,
      {required IconData icon,
      required Color color,
      required String title,
      required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
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
