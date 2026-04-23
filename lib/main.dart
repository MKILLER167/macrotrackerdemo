import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/language_cubit.dart';
import 'cubits/theme_cubit.dart';
import 'cubits/navigation_cubit.dart';
import 'cubits/user_cubit.dart';
import 'cubits/nutrition_cubit.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const NutriTrackerApp());
}

class NutriTrackerApp extends StatelessWidget {
  const NutriTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => NutritionCubit()),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return Directionality(
                textDirection: languageState.textDirection,
                child: MaterialApp(
                  title: 'NutriTracker',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeState.themeMode,
                  home: const MainScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
