import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/nutrition_model.dart';
import 'package:equatable/equatable.dart';

class DailyNutrition {
  final DateTime date;
  final int caloriesConsumed;
  final double proteinConsumed;
  final double carbsConsumed;
  final double fatConsumed;
  final int waterConsumedMl;
  final List<MealEntry> meals;

  const DailyNutrition({
    required this.date,
    this.caloriesConsumed = 0,
    this.proteinConsumed = 0.0,
    this.carbsConsumed = 0.0,
    this.fatConsumed = 0.0,
    this.waterConsumedMl = 0,
    this.meals = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'caloriesConsumed': caloriesConsumed,
      'proteinConsumed': proteinConsumed,
      'carbsConsumed': carbsConsumed,
      'fatConsumed': fatConsumed,
      'waterConsumedMl': waterConsumedMl,
      'meals': meals.map((m) => m.toJson()).toList(),
    };
  }

  factory DailyNutrition.fromJson(Map<String, dynamic> json) {
    return DailyNutrition(
      date: DateTime.parse(json['date']),
      caloriesConsumed: json['caloriesConsumed'] ?? 0,
      proteinConsumed: (json['proteinConsumed'] ?? 0.0).toDouble(),
      carbsConsumed: (json['carbsConsumed'] ?? 0.0).toDouble(),
      fatConsumed: (json['fatConsumed'] ?? 0.0).toDouble(),
      waterConsumedMl: json['waterConsumedMl'] ?? 0,
      meals: (json['meals'] as List?)
              ?.map((m) => MealEntry.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class NutritionState extends Equatable {
  final Map<String, DailyNutrition> history;

  DailyNutrition get today => _getTodayStats();

  const NutritionState({this.history = const {}});

  DailyNutrition _getTodayStats() {
    final today = DateTime.now();
    final key =
        '${today.year}-${today.month.padLeft(2, '0')}-${today.day.padLeft(2, '0')}';
    return history[key] ?? DailyNutrition(date: today);
  }

  @override
  List<Object> get props => [history];
}

extension IntPad on int {
  String padLeft(int width, [String padding = ' ']) =>
      toString().padLeft(width, padding);
}

class NutritionCubit extends Cubit<NutritionState> {
  NutritionCubit() : super(const NutritionState()) {
    _loadStats();
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.padLeft(2, '0')}-${date.day.padLeft(2, '0')}';
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString('dailyNutrition');

    if (statsJson != null) {
      final statsMap = json.decode(statsJson) as Map<String, dynamic>;
      final history = statsMap.map(
        (key, value) => MapEntry(key, DailyNutrition.fromJson(value)),
      );
      emit(NutritionState(history: history));
    }
  }

  Future<void> _saveStats(Map<String, DailyNutrition> newHistory) async {
    final prefs = await SharedPreferences.getInstance();
    final statsMap =
        newHistory.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString('dailyNutrition', json.encode(statsMap));
    emit(NutritionState(history: newHistory));
  }

  Future<void> addWater(int amountMl) async {
    final today = DateTime.now();
    final key = _getDateKey(today);

    final currentHistory = Map<String, DailyNutrition>.from(state.history);
    final currentStats = currentHistory[key] ?? DailyNutrition(date: today);

    currentHistory[key] = DailyNutrition(
      date: today,
      caloriesConsumed: currentStats.caloriesConsumed,
      proteinConsumed: currentStats.proteinConsumed,
      carbsConsumed: currentStats.carbsConsumed,
      fatConsumed: currentStats.fatConsumed,
      waterConsumedMl: currentStats.waterConsumedMl + amountMl,
      meals: currentStats.meals,
    );

    await _saveStats(currentHistory);
  }

  Future<void> addMeal(MealEntry meal) async {
    final today = DateTime.now();
    final key = _getDateKey(today);

    final currentHistory = Map<String, DailyNutrition>.from(state.history);
    final currentStats = currentHistory[key] ?? DailyNutrition(date: today);

    final updatedMeals = List<MealEntry>.from(currentStats.meals)..add(meal);

    currentHistory[key] = DailyNutrition(
      date: today,
      caloriesConsumed: currentStats.caloriesConsumed + meal.calories,
      proteinConsumed: currentStats.proteinConsumed + meal.protein,
      carbsConsumed: currentStats.carbsConsumed + meal.carbs,
      fatConsumed: currentStats.fatConsumed + meal.fat,
      waterConsumedMl: currentStats.waterConsumedMl,
      meals: updatedMeals,
    );

    await _saveStats(currentHistory);
  }
}
