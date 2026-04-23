import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user_cubit.dart';
import '../cubits/language_cubit.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final l10n = AppLocalizations(langState.locale);
        final isAr = langState.isArabic;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.translate('profile'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocBuilder<UserCubit, UserState>(
            builder: (context, userState) {
              final user = userState.user;
              final stats = userState.stats;

              if (user == null || user.profile == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final profile = user.profile!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileHeader(
                        context, profile.name, profile.profileImageUrl),
                    const SizedBox(height: 32),
                    _buildStatsRow(context, stats, l10n),
                    const SizedBox(height: 32),
                    _buildInfoCard(context,
                        title: isAr
                            ? 'Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„ØªØºØ°ÙŠØ©'
                            : 'Nutrition Goals',
                        children: [
                          _buildInfoRow(
                              context,
                              isAr
                                  ? 'Ø§Ù„Ø³Ø¹Ø±Ø§Øª Ø§Ù„Ù…Ø³ØªÙ‡Ø¯ÙØ©'
                                  : 'Target Calories',
                              '${profile.targetCalories} kcal'),
                          _buildInfoRow(
                              context,
                              isAr
                                  ? 'Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø§Ù„Ù…Ø§Ø¡'
                                  : 'Target Water',
                              '${profile.targetWaterMl} ml'),
                          _buildInfoRow(
                              context,
                              l10n.translate('diet_plan'),
                              isAr
                                  ? (userState.activePlan?.nameAr ?? '')
                                  : (userState.activePlan?.nameEn ?? '')),
                        ]),
                    const SizedBox(height: 24),
                    _buildInfoCard(context,
                        title: l10n.translate('settings'),
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.language,
                                color: Theme.of(context).colorScheme.primary),
                            title: Text(isAr ? 'Ø§Ù„Ù„ØºØ©' : 'Language'),
                            trailing: Text(l10n.translate('change_language')),
                            onTap: () {
                              context.read<LanguageCubit>().toggleLanguage();
                            },
                          ),
                        ]),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, String name, String? imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          child: imageUrl == null
              ? Icon(Icons.person,
                  size: 50, color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
      BuildContext context, dynamic stats, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatBox(context, Icons.star, stats?.level.toString() ?? '1',
            l10n.translate('levels')),
        _buildStatBox(context, Icons.local_fire_department,
            stats?.streakDays.toString() ?? '0', l10n.translate('streak')),
      ],
    );
  }

  Widget _buildStatBox(
      BuildContext context, IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
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
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
