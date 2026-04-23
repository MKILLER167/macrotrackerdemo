class AppConstants {
  // App Info
  static const String appName = 'FitTracker';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Your comprehensive fitness tracking companion';

  // API Keys (Replace with actual keys in production)
  static const String googleNutritionApiKey = 'YOUR_GOOGLE_API_KEY_HERE';
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';

  // Subscription Prices
  static const String premiumPrice = '\$9.99';
  static const String proPrice = '\$19.99';

  // Default Values
  static const int defaultCalorieGoal = 2000;
  static const double defaultProteinGoal = 150.0;
  static const double defaultCarbsGoal = 200.0;
  static const double defaultFatGoal = 65.0;

  // XP Values
  static const int xpQuickFood = 10;
  static const int xpSearchFood = 15;
  static const int xpCustomFood = 15;
  static const int xpWorkout = 20;
  static const int xpDailyLogin = 5;
  static const int xpStreak7Days = 50;
  static const int xpStreak30Days = 200;

  // Level Formula Constants
  static const int xpPerLevelBase = 100;

  // Nutrition Ranges (for color coding)
  static const double calorieDeficitRatio = 0.7;
  static const double calorieTargetRatio = 1.0;
  static const double calorieSurplusRatio = 1.2;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);

  // Storage Keys
  static const String keyIsFirstLaunch = 'isFirstLaunch';
  static const String keyHasCompletedOnboarding = 'hasCompletedOnboarding';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyIsGuestMode = 'isGuestMode';
  static const String keyUserId = 'userId';
  static const String keyUserProfile = 'userProfile';
  static const String keyLanguageCode = 'languageCode';
  static const String keyIsDarkMode = 'isDarkMode';
  static const String keyDailyStats = 'dailyStats';

  // UI Constants
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 20.0;

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Nutrition Units
  static const String unitServing = 'serving';
  static const String unitCup = 'cup';
  static const String unitGram = 'gram';
  static const String unitPiece = 'piece';
  static const String unitTbsp = 'tbsp';
  static const String unitTsp = 'tsp';
  static const String unitOz = 'oz';
  static const String unitMl = 'ml';

  // Workout Categories
  static const String categoryCardio = 'Cardio';
  static const String categoryStrength = 'Strength';
  static const String categoryFlexibility = 'Flexibility';
  static const String categoryHIIT = 'HIIT';

  // Achievement Milestones
  static const int milestone10Meals = 10;
  static const int milestone50Meals = 50;
  static const int milestone100Meals = 100;
  static const int milestone10Workouts = 10;
  static const int milestone50Workouts = 50;
  static const int milestone100Workouts = 100;

  // Streak Milestones
  static const int streak7Days = 7;
  static const int streak14Days = 14;
  static const int streak30Days = 30;
  static const int streak90Days = 90;
  static const int streak365Days = 365;

  // Barcode Prefixes (for validation)
  static const List<String> validBarcodePrefixes = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];

  // Error Messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorNoResults = 'No results found.';
  static const String errorInvalidInput =
      'Invalid input. Please check your data.';
  static const String errorNotLoggedIn = 'Please log in to continue.';
  static const String errorPremiumRequired =
      'This feature requires a premium subscription.';

  // Success Messages
  static const String successMealLogged = 'Meal logged successfully!';
  static const String successWorkoutLogged = 'Workout logged successfully!';
  static const String successProfileUpdated = 'Profile updated successfully!';
  static const String successGoalSet = 'Goal set successfully!';

  // URLs
  static const String privacyPolicyUrl = 'https://fittracker.app/privacy';
  static const String termsOfServiceUrl = 'https://fittracker.app/terms';
  static const String helpCenterUrl = 'https://fittracker.app/help';
  static const String feedbackUrl = 'https://fittracker.app/feedback';

  // Regular Expressions
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
  );
}
