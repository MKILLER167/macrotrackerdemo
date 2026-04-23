import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/diet_plan.dart';

class UserState {
  final UserModel? user;
  final UserStats? stats;
  final DietPlan? activePlan;

  const UserState({
    this.user,
    this.stats,
    this.activePlan,
  });

  UserState copyWith({
    UserModel? user,
    UserStats? stats,
    DietPlan? activePlan,
  }) {
    return UserState(
      user: user ?? this.user,
      stats: stats ?? this.stats,
      activePlan: activePlan ?? this.activePlan,
    );
  }
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_model');
    final statsJson = prefs.getString('user_stats');

    UserModel? user;
    if (userJson != null) {
      user = UserModel.fromJson(json.decode(userJson));
    } else {
      // Default Mock User
      user = UserModel(
        id: '1',
        isGuest: false,
        isOnboarded: true,
        subscriptionTier: SubscriptionTier.premium,
        createdAt: DateTime.now(),
        profile: const UserProfile(
          name: 'Ahmed',
          age: 28,
          gender: Gender.male,
          height: 180,
          weight: 75,
          goal: GoalType.maintain,
          targetWeight: 75,
          activityLevel: ActivityLevel.moderatelyActive,
          dietPlan: DietPlanType.intermittentFasting,
          targetCalories: 2200,
          targetWaterMl: 3000,
        ),
      );
    }

    UserStats? stats;
    if (statsJson != null) {
      stats = UserStats.fromJson(json.decode(statsJson));
    } else {
      stats = UserStats(
        userId: user.id,
        level: 3,
        xp: 2450,
        streakDays: 12,
        totalMealsLogged: 45,
        totalWaterLogged: 120,
        achievements: const ['first_meal', '7_day_streak'],
        lastActiveDate: DateTime.now(),
      );
    }

    final activePlan = user.profile != null
        ? DietPlanService.getPlan(user.profile!.dietPlan)
        : null;

    emit(UserState(user: user, stats: stats, activePlan: activePlan));
  }

  Future<void> updateDietPlan(DietPlanType newType) async {
    if (state.user?.profile == null) return;

    final updatedProfile = state.user!.profile!.copyWith(dietPlan: newType);
    final updatedUser = state.user!.copyWith(profile: updatedProfile);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_model', json.encode(updatedUser.toJson()));

    emit(state.copyWith(
        user: updatedUser, activePlan: DietPlanService.getPlan(newType)));
  }

  Future<void> completeOnboarding(UserProfile profile) async {
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isGuest: false,
      isOnboarded: true,
      subscriptionTier: SubscriptionTier.free,
      createdAt: DateTime.now(),
      profile: profile,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_model', json.encode(newUser.toJson()));

    final newStats = state.stats?.copyWith(userId: newUser.id) ??
        UserStats(
          userId: newUser.id,
          level: 1,
          xp: 0,
          streakDays: 0,
          totalMealsLogged: 0,
          totalWaterLogged: 0,
          achievements: const [],
          lastActiveDate: DateTime.now(),
        );

    emit(UserState(
        user: newUser,
        stats: newStats,
        activePlan: DietPlanService.getPlan(profile.dietPlan)));
  }
}
