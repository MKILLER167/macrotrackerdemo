import '../models/nutrition_model.dart';

class QuickFoodsData {
  static final List<QuickFood> commonFoods = [
    // Breakfast
    QuickFood(
      name: 'Scrambled Eggs (2 large)',
      calories: 140,
      protein: 12,
      carbs: 1,
      fat: 10,
      unit: 'serving',
      category: 'breakfast',
    ),
    QuickFood(
      name: 'Greek Yogurt',
      calories: 130,
      protein: 15,
      carbs: 9,
      fat: 5,
      unit: 'cup',
      category: 'breakfast',
    ),
    QuickFood(
      name: 'Oatmeal',
      calories: 150,
      protein: 5,
      carbs: 27,
      fat: 3,
      unit: 'cup',
      category: 'breakfast',
    ),
    QuickFood(
      name: 'Banana',
      calories: 105,
      protein: 1,
      carbs: 27,
      fat: 0,
      unit: 'medium',
      category: 'breakfast',
    ),
    QuickFood(
      name: 'Whole Wheat Toast',
      calories: 80,
      protein: 4,
      carbs: 14,
      fat: 1,
      unit: 'slice',
      category: 'breakfast',
    ),

    // Lunch/Dinner
    QuickFood(
      name: 'Grilled Chicken Breast',
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 4,
      unit: '100g',
      category: 'protein',
    ),
    QuickFood(
      name: 'Brown Rice',
      calories: 216,
      protein: 5,
      carbs: 45,
      fat: 2,
      unit: 'cup',
      category: 'carbs',
    ),
    QuickFood(
      name: 'Quinoa',
      calories: 222,
      protein: 8,
      carbs: 39,
      fat: 4,
      unit: 'cup',
      category: 'carbs',
    ),
    QuickFood(
      name: 'Salmon Fillet',
      calories: 206,
      protein: 22,
      carbs: 0,
      fat: 12,
      unit: '100g',
      category: 'protein',
    ),
    QuickFood(
      name: 'Sweet Potato',
      calories: 112,
      protein: 2,
      carbs: 26,
      fat: 0,
      unit: 'medium',
      category: 'carbs',
    ),

    // Vegetables
    QuickFood(
      name: 'Broccoli',
      calories: 55,
      protein: 4,
      carbs: 11,
      fat: 1,
      unit: 'cup',
      category: 'vegetables',
    ),
    QuickFood(
      name: 'Spinach',
      calories: 7,
      protein: 1,
      carbs: 1,
      fat: 0,
      unit: 'cup',
      category: 'vegetables',
    ),
    QuickFood(
      name: 'Avocado',
      calories: 234,
      protein: 3,
      carbs: 12,
      fat: 21,
      unit: 'medium',
      category: 'fats',
    ),
    QuickFood(
      name: 'Mixed Salad',
      calories: 20,
      protein: 2,
      carbs: 4,
      fat: 0,
      unit: 'cup',
      category: 'vegetables',
    ),

    // Snacks
    QuickFood(
      name: 'Apple',
      calories: 95,
      protein: 0,
      carbs: 25,
      fat: 0,
      unit: 'medium',
      category: 'snacks',
    ),
    QuickFood(
      name: 'Almonds',
      calories: 163,
      protein: 6,
      carbs: 6,
      fat: 14,
      unit: '28g',
      category: 'snacks',
    ),
    QuickFood(
      name: 'Greek Yogurt Cup',
      calories: 100,
      protein: 17,
      carbs: 6,
      fat: 0,
      unit: 'container',
      category: 'snacks',
    ),
    QuickFood(
      name: 'Protein Bar',
      calories: 200,
      protein: 20,
      carbs: 20,
      fat: 7,
      unit: 'bar',
      category: 'snacks',
    ),

    // Beverages
    QuickFood(
      name: 'Protein Shake',
      calories: 120,
      protein: 25,
      carbs: 3,
      fat: 1,
      unit: 'scoop',
      category: 'beverages',
    ),
    QuickFood(
      name: 'Green Tea',
      calories: 2,
      protein: 0,
      carbs: 0,
      fat: 0,
      unit: 'cup',
      category: 'beverages',
    ),
    QuickFood(
      name: 'Black Coffee',
      calories: 2,
      protein: 0,
      carbs: 0,
      fat: 0,
      unit: 'cup',
      category: 'beverages',
    ),
  ];

  static Map<String, String> getCategoryNames(String languageCode) {
    if (languageCode == 'ar') {
      return {
        'breakfast': 'الإفطار',
        'protein': 'البروتين',
        'carbs': 'الكربوهيدرات',
        'vegetables': 'الخضروات',
        'fats': 'الدهون',
        'snacks': 'الوجبات الخفيفة',
        'beverages': 'المشروبات',
      };
    } else {
      return {
        'breakfast': 'Breakfast',
        'protein': 'Protein',
        'carbs': 'Carbs',
        'vegetables': 'Vegetables',
        'fats': 'Fats',
        'snacks': 'Snacks',
        'beverages': 'Beverages',
      };
    }
  }

  static Map<String, String> getMealTypeNames(String languageCode) {
    if (languageCode == 'ar') {
      return {
        'breakfast': 'الإفطار',
        'lunch': 'الغداء',
        'dinner': 'العشاء',
        'snack': 'وجبة خفيفة',
      };
    } else {
      return {
        'breakfast': 'Breakfast',
        'lunch': 'Lunch',
        'dinner': 'Dinner',
        'snack': 'Snack',
      };
    }
  }
}
