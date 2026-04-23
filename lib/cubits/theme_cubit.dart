import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isDark;

  const ThemeState({
    required this.themeMode,
    required this.isDark,
  });

  @override
  List<Object> get props => [themeMode, isDark];
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(const ThemeState(
          themeMode:
              ThemeMode.dark, // Default to dark for premium glassmorphism
          isDark: true,
        )) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? true;
    emit(ThemeState(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      isDark: isDark,
    ));
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newIsDark = !state.isDark;
    await prefs.setBool('isDark', newIsDark);
    emit(ThemeState(
      themeMode: newIsDark ? ThemeMode.dark : ThemeMode.light,
      isDark: newIsDark,
    ));
  }
}
