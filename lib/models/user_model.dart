import 'package:flutter/foundation.dart';

enum SubscriptionTier { free, premium, pro }

enum Gender { male, female, other }

enum DietPlanType { standard, keto, intermittentFasting, highProtein, vegan }

@immutable
class UserProfile {
  final String name;
  final int age;
  final Gender gender;
  final double height; // in cm
  final double weight; // in kg
  final DietPlanType dietPlan;
  final int targetCalories;
  final int targetWaterMl;
  final String? profileImageUrl;

  const UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.dietPlan,
    required this.targetCalories,
    required this.targetWaterMl,
    this.profileImageUrl,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    Gender? gender,
    double? height,
    double? weight,
    DietPlanType? dietPlan,
    int? targetCalories,
    int? targetWaterMl,
    String? profileImageUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      dietPlan: dietPlan ?? this.dietPlan,
      targetCalories: targetCalories ?? this.targetCalories,
      targetWaterMl: targetWaterMl ?? this.targetWaterMl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender.index,
      'height': height,
      'weight': weight,
      'dietPlan': dietPlan.index,
      'targetCalories': targetCalories,
      'targetWaterMl': targetWaterMl,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      age: json['age'] as int,
      gender: Gender.values[json['gender'] as int],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      dietPlan: DietPlanType.values[json['dietPlan'] as int],
      targetCalories: json['targetCalories'] as int,
      targetWaterMl: json['targetWaterMl'] as int? ?? 2500,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}

@immutable
class UserModel {
  final String id;
  final String? email;
  final bool isGuest;
  final bool isOnboarded;
  final SubscriptionTier subscriptionTier;
  final UserProfile? profile;
  final DateTime createdAt;
  final DateTime? subscriptionExpiresAt;

  const UserModel({
    required this.id,
    this.email,
    required this.isGuest,
    required this.isOnboarded,
    required this.subscriptionTier,
    this.profile,
    required this.createdAt,
    this.subscriptionExpiresAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    bool? isGuest,
    bool? isOnboarded,
    SubscriptionTier? subscriptionTier,
    UserProfile? profile,
    DateTime? createdAt,
    DateTime? subscriptionExpiresAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      profile: profile ?? this.profile,
      createdAt: createdAt ?? this.createdAt,
      subscriptionExpiresAt:
          subscriptionExpiresAt ?? this.subscriptionExpiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'isGuest': isGuest,
      'isOnboarded': isOnboarded,
      'subscriptionTier': subscriptionTier.index,
      'profile': profile?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'subscriptionExpiresAt': subscriptionExpiresAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      isGuest: json['isGuest'] as bool,
      isOnboarded: json['isOnboarded'] as bool,
      subscriptionTier:
          SubscriptionTier.values[json['subscriptionTier'] as int],
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.parse(json['subscriptionExpiresAt'] as String)
          : null,
    );
  }
}

@immutable
class UserStats {
  final String userId;
  final int level;
  final int xp;
  final int streakDays;
  final int totalMealsLogged;
  final int totalWaterLogged;
  final List<String> achievements;
  final DateTime lastActiveDate;

  const UserStats({
    required this.userId,
    required this.level,
    required this.xp,
    required this.streakDays,
    required this.totalMealsLogged,
    required this.totalWaterLogged,
    required this.achievements,
    required this.lastActiveDate,
  });

  UserStats copyWith({
    String? userId,
    int? level,
    int? xp,
    int? streakDays,
    int? totalMealsLogged,
    int? totalWaterLogged,
    List<String>? achievements,
    DateTime? lastActiveDate,
  }) {
    return UserStats(
      userId: userId ?? this.userId,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streakDays: streakDays ?? this.streakDays,
      totalMealsLogged: totalMealsLogged ?? this.totalMealsLogged,
      totalWaterLogged: totalWaterLogged ?? this.totalWaterLogged,
      achievements: achievements ?? this.achievements,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  int get xpForNextLevel => (level * 1000);
  int get xpProgress => xp % 1000;
  double get xpPercentage => (xpProgress / 1000).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'level': level,
      'xp': xp,
      'streakDays': streakDays,
      'totalMealsLogged': totalMealsLogged,
      'totalWaterLogged': totalWaterLogged,
      'achievements': achievements,
      'lastActiveDate': lastActiveDate.toIso8601String(),
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'] as String,
      level: json['level'] as int,
      xp: json['xp'] as int,
      streakDays: json['streakDays'] as int,
      totalMealsLogged: json['totalMealsLogged'] as int,
      totalWaterLogged: json['totalWaterLogged'] as int? ?? 0,
      achievements: List<String>.from(json['achievements'] as List),
      lastActiveDate: DateTime.parse(json['lastActiveDate'] as String),
    );
  }
}

class XPGainResult {
  final UserStats updatedStats;
  final bool leveledUp;
  final int levelsGained;

  const XPGainResult({
    required this.updatedStats,
    required this.leveledUp,
    required this.levelsGained,
  });
}
