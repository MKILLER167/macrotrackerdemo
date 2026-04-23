import 'package:intl/intl.dart';

class Helpers {
  /// Format date to readable string
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format time to HH:mm
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Get greeting based on time of day
  static String getGreeting(String languageCode) {
    final hour = DateTime.now().hour;

    if (languageCode == 'ar') {
      if (hour < 12) return 'صباح الخير';
      if (hour < 18) return 'مساء الخير';
      return 'مساء الخير';
    } else {
      if (hour < 12) return 'Good morning';
      if (hour < 18) return 'Good afternoon';
      return 'Good evening';
    }
  }

  /// Calculate BMI
  static double calculateBMI(double weightKg, double heightCm) {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Get BMI category
  static String getBMICategory(double bmi, String languageCode) {
    if (languageCode == 'ar') {
      if (bmi < 18.5) return 'نحيف';
      if (bmi < 25) return 'وزن طبيعي';
      if (bmi < 30) return 'زيادة وزن';
      return 'سمنة';
    } else {
      if (bmi < 18.5) return 'Underweight';
      if (bmi < 25) return 'Normal';
      if (bmi < 30) return 'Overweight';
      return 'Obese';
    }
  }

  /// Calculate TDEE (Total Daily Energy Expenditure)
  static int calculateTDEE({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
  }) {
    // Calculate BMR using Mifflin-St Jeor Equation
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }

    // Activity multipliers
    final activityMultipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
    };

    final multiplier = activityMultipliers[activityLevel] ?? 1.2;
    return (bmr * multiplier).round();
  }

  /// Calculate calorie goal based on fitness goal
  static int calculateCalorieGoal({
    required int tdee,
    required String goal,
  }) {
    switch (goal.toLowerCase()) {
      case 'weight_loss':
        return (tdee * 0.8).round(); // 20% deficit
      case 'muscle_gain':
        return (tdee * 1.1).round(); // 10% surplus
      case 'athletic':
        return (tdee * 1.15).round(); // 15% surplus
      case 'maintenance':
      default:
        return tdee;
    }
  }

  /// Calculate macro split
  static Map<String, double> calculateMacros({
    required int calories,
    required String goal,
  }) {
    double proteinRatio, carbsRatio, fatRatio;

    switch (goal.toLowerCase()) {
      case 'weight_loss':
        proteinRatio = 0.40;
        carbsRatio = 0.30;
        fatRatio = 0.30;
        break;
      case 'muscle_gain':
        proteinRatio = 0.30;
        carbsRatio = 0.45;
        fatRatio = 0.25;
        break;
      case 'athletic':
        proteinRatio = 0.25;
        carbsRatio = 0.50;
        fatRatio = 0.25;
        break;
      case 'maintenance':
      default:
        proteinRatio = 0.30;
        carbsRatio = 0.40;
        fatRatio = 0.30;
        break;
    }

    return {
      'protein':
          (calories * proteinRatio / 4).roundToDouble(), // 4 cal per gram
      'carbs': (calories * carbsRatio / 4).roundToDouble(), // 4 cal per gram
      'fat': (calories * fatRatio / 9).roundToDouble(), // 9 cal per gram
    };
  }

  /// Format number with commas
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Get time ago string
  static String getTimeAgo(DateTime dateTime, String languageCode) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (languageCode == 'ar') {
      if (difference.inSeconds < 60) return 'منذ لحظات';
      if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
      if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعة';
      if (difference.inDays < 7) return 'منذ ${difference.inDays} يوم';
      if (difference.inDays < 30) {
        return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
      }
      if (difference.inDays < 365) {
        return 'منذ ${(difference.inDays / 30).floor()} شهر';
      }
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    } else {
      if (difference.inSeconds < 60) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()}w ago';
      }
      if (difference.inDays < 365) {
        return '${(difference.inDays / 30).floor()}mo ago';
      }
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  /// Validate email
  static bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate password (min 6 chars, at least 1 letter and 1 number)
  static bool isValidPassword(String password) {
    if (password.length < 6) return false;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    return hasLetter && hasNumber;
  }

  /// Convert weight units (kg to lbs or vice versa)
  static double convertWeight(double weight, {bool kgToLbs = true}) {
    if (kgToLbs) {
      return weight * 2.20462;
    } else {
      return weight / 2.20462;
    }
  }

  /// Convert height units (cm to inches or vice versa)
  static double convertHeight(double height, {bool cmToInches = true}) {
    if (cmToInches) {
      return height / 2.54;
    } else {
      return height * 2.54;
    }
  }

  /// Generate random ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Get percentage
  static double getPercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total * 100).clamp(0.0, 100.0);
  }

  /// Get color for calorie progress
  static String getCalorieProgressColor(int consumed, int goal) {
    final ratio = consumed / goal;
    if (ratio < 0.7) return 'blue';
    if (ratio < 1.0) return 'green';
    if (ratio < 1.2) return 'orange';
    return 'red';
  }

  /// Format duration (e.g., 90 minutes → "1h 30m")
  static String formatDuration(int minutes, String languageCode) {
    if (minutes < 60) {
      return languageCode == 'ar' ? '$minutes دقيقة' : '${minutes}m';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (languageCode == 'ar') {
      if (remainingMinutes == 0) return '$hours ساعة';
      return '$hours ساعة $remainingMinutes دقيقة';
    } else {
      if (remainingMinutes == 0) return '${hours}h';
      return '${hours}h ${remainingMinutes}m';
    }
  }

  /// Get day of week
  static String getDayOfWeek(DateTime date, String languageCode) {
    final days = languageCode == 'ar'
        ? [
            'الأحد',
            'الإثنين',
            'الثلاثاء',
            'الأربعاء',
            'الخميس',
            'الجمعة',
            'السبت'
          ]
        : [
            'Sunday',
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday'
          ];

    return days[date.weekday % 7];
  }

  /// Get month name
  static String getMonthName(int month, String languageCode) {
    final months = languageCode == 'ar'
        ? [
            'يناير',
            'فبراير',
            'مارس',
            'أبريل',
            'مايو',
            'يونيو',
            'يوليو',
            'أغسطس',
            'سبتمبر',
            'أكتوبر',
            'نوفمبر',
            'ديسمبر'
          ]
        : [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December'
          ];

    return months[month - 1];
  }

  /// Is same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Get days between
  static int getDaysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }
}
