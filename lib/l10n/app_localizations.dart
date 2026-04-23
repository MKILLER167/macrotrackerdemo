import 'package:flutter/material.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'home': 'Home',
      'meals': 'Meals',
      'guides': 'Guides',
      'profile': 'Profile',
      'welcome_back': 'Welcome back,',
      'calories': 'Calories',
      'water_intake': 'Water Intake',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fat': 'Fat',
      'quick_actions': 'Quick Actions',
      'add_meal': 'Add Meal',
      'add_water': 'Add Water',
      'recent_meals': 'Recent Meals',
      'no_meals': 'No meals logged yet',
      'diet_plan': 'Diet Plan',
      'tips_tricks': 'Tricks & Tips',
      'healthy_habits': 'Healthy Habits',
      'nutrition_guide': 'Nutrition Guide',
      'water': 'Water',
      'change_language': 'عربي',
      'stay_hydrated': 'Stay Hydrated!',
      'settings': 'Settings',
      'levels': 'Levels',
      'streak': 'Day Streak',
      'today_stats': 'Today\'s Stats',
    },
    'ar': {
      'home': 'الرئيسية',
      'meals': 'الوجبات',
      'guides': 'الإرشادات',
      'profile': 'الملف',
      'welcome_back': 'مرحباً بعودتك،',
      'calories': 'سعرات',
      'water_intake': 'استهلاك الماء',
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fat': 'دهون',
      'quick_actions': 'إجراءات سريعة',
      'add_meal': 'إضافة وجبة',
      'add_water': 'إضافة ماء',
      'recent_meals': 'الوجبات الأخيرة',
      'no_meals': 'لم يتم تسجيل وجبات بعد',
      'diet_plan': 'خطة النظام الغذائي',
      'tips_tricks': 'حيل ونصائح',
      'healthy_habits': 'عادات صحية',
      'nutrition_guide': 'دليل التغذية',
      'water': 'الماء',
      'change_language': 'English',
      'stay_hydrated': 'حافظ على رطوبتك!',
      'settings': 'الإعدادات',
      'levels': 'مستويات',
      'streak': 'أيام متتالية',
      'today_stats': 'إحصائيات اليوم',
    }
  };

  final String locale;

  AppLocalizations(this.locale);

  String translate(String key) {
    return _translations[locale]?[key] ?? key;
  }
}

extension AppLocalizationsContext on BuildContext {
  String l10n(String key) {
    // We will extract locale from LanguageCubit state dynamically
    // But for direct extension, if we provide AppLocalizations via RepositoryProvider or just pass the string.
    // To make it super simple, we'll expose a static method that LanguageCubit will use,
    // or just pass locale directly. Since we use Cubit, we can use context.read<LanguageCubit>().state.locale
    return key; // Placeholder, real implementation below.
  }
}
