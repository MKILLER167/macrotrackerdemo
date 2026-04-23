import '../models/user_model.dart';

class NutritionCalculator {
  /// Calculate Basal Metabolic Rate using Mifflin-St Jeor Equation
  static double calculateBMR(
      Gender gender, double weightKg, double heightCm, int ageYears) {
    if (gender == Gender.male) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) + 5;
    } else if (gender == Gender.female) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) - 161;
    } else {
      // Average for non-binary/other
      double maleBMR = (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) + 5;
      double femaleBMR =
          (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) - 161;
      return (maleBMR + femaleBMR) / 2;
    }
  }

  static double getActivityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
    }
  }

  static int calculateTDEE(double bmr, ActivityLevel level) {
    return (bmr * getActivityMultiplier(level)).round();
  }

  static int calculateTargetCalories(int tdee, GoalType goal) {
    switch (goal) {
      case GoalType.loseWeight:
        return tdee - 500; // Target ~0.5kg/week loss
      case GoalType.gainMuscle:
        return tdee + 300; // Target ~0.3kg/week gain
      case GoalType.maintain:
        return tdee;
    }
  }

  /// Calculates the estimated number of weeks to reach a target weight
  static int estimatedWeeksToGoal(
      double currentWeight, double targetWeight, GoalType goal) {
    if (goal == GoalType.maintain) return 0;

    double weightDiff = (currentWeight - targetWeight).abs();

    if (goal == GoalType.loseWeight) {
      return (weightDiff / 0.5).ceil(); // 0.5 kg per week
    } else {
      return (weightDiff / 0.3).ceil(); // ~0.3 kg per week
    }
  }
}
