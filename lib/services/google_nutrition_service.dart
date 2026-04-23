import 'package:flutter/foundation.dart';
import '../models/nutrition_model.dart';

class GoogleNutritionService {
  static const String apiKey = 'YOUR_GOOGLE_API_KEY_HERE';
  static const String baseUrl = 'https://www.googleapis.com/customsearch/v1';

  // Mock food database for demonstration - replace with real API calls
  static final List<NutritionData> _mockFoodDatabase = [
    NutritionData(
      name: 'Apple',
      calories: 95,
      servingSize: '1',
      servingUnit: 'medium apple',
      protein: 0.5,
      carbs: 25,
      fat: 0.3,
      fiber: 4.4,
      sugar: 19,
    ),
    NutritionData(
      name: 'Banana',
      calories: 105,
      servingSize: '1',
      servingUnit: 'medium banana',
      protein: 1.3,
      carbs: 27,
      fat: 0.4,
      fiber: 3.1,
      sugar: 14,
    ),
    NutritionData(
      name: 'Chicken Breast',
      brand: 'Generic',
      calories: 165,
      servingSize: '100',
      servingUnit: 'grams',
      protein: 31,
      carbs: 0,
      fat: 3.6,
      fiber: 0,
      sugar: 0,
    ),
    NutritionData(
      name: 'Brown Rice',
      calories: 112,
      servingSize: '100',
      servingUnit: 'grams cooked',
      protein: 2.6,
      carbs: 23,
      fat: 0.9,
      fiber: 1.8,
      sugar: 0.4,
    ),
    NutritionData(
      name: 'Greek Yogurt',
      brand: 'Plain',
      calories: 100,
      servingSize: '170',
      servingUnit: 'grams',
      protein: 17,
      carbs: 6,
      fat: 0,
      fiber: 0,
      sugar: 6,
    ),
    NutritionData(
      name: 'Almonds',
      calories: 164,
      servingSize: '28',
      servingUnit: 'grams (24 nuts)',
      protein: 6,
      carbs: 6,
      fat: 14,
      fiber: 3.5,
      sugar: 1.2,
    ),
    NutritionData(
      name: 'Salmon',
      calories: 208,
      servingSize: '100',
      servingUnit: 'grams',
      protein: 22,
      carbs: 0,
      fat: 12,
      fiber: 0,
      sugar: 0,
    ),
    NutritionData(
      name: 'Avocado',
      calories: 160,
      servingSize: '100',
      servingUnit: 'grams',
      protein: 2,
      carbs: 9,
      fat: 15,
      fiber: 7,
      sugar: 0.7,
    ),
    NutritionData(
      name: 'Whole Wheat Bread',
      calories: 69,
      servingSize: '1',
      servingUnit: 'slice',
      protein: 3.6,
      carbs: 12,
      fat: 1.2,
      fiber: 1.9,
      sugar: 1.4,
    ),
    NutritionData(
      name: 'Eggs',
      calories: 155,
      servingSize: '2',
      servingUnit: 'large eggs',
      protein: 13,
      carbs: 1.1,
      fat: 11,
      fiber: 0,
      sugar: 1.1,
    ),
    NutritionData(
      name: 'Oatmeal',
      calories: 150,
      servingSize: '40',
      servingUnit: 'grams dry',
      protein: 5,
      carbs: 27,
      fat: 3,
      fiber: 4,
      sugar: 1,
    ),
    NutritionData(
      name: 'Broccoli',
      calories: 55,
      servingSize: '1',
      servingUnit: 'cup',
      protein: 4,
      carbs: 11,
      fat: 0.6,
      fiber: 2.4,
      sugar: 2.2,
    ),
    NutritionData(
      name: 'Sweet Potato',
      calories: 112,
      servingSize: '1',
      servingUnit: 'medium',
      protein: 2,
      carbs: 26,
      fat: 0,
      fiber: 4,
      sugar: 5,
    ),
    NutritionData(
      name: 'Tuna',
      brand: 'Canned in Water',
      calories: 116,
      servingSize: '100',
      servingUnit: 'grams',
      protein: 26,
      carbs: 0,
      fat: 1,
      fiber: 0,
      sugar: 0,
    ),
    NutritionData(
      name: 'Quinoa',
      calories: 222,
      servingSize: '1',
      servingUnit: 'cup cooked',
      protein: 8,
      carbs: 39,
      fat: 4,
      fiber: 5,
      sugar: 2,
    ),
    NutritionData(
      name: 'Spinach',
      calories: 7,
      servingSize: '1',
      servingUnit: 'cup raw',
      protein: 0.9,
      carbs: 1.1,
      fat: 0.1,
      fiber: 0.7,
      sugar: 0.1,
    ),
    NutritionData(
      name: 'Blueberries',
      calories: 84,
      servingSize: '1',
      servingUnit: 'cup',
      protein: 1.1,
      carbs: 21,
      fat: 0.5,
      fiber: 3.6,
      sugar: 15,
    ),
    NutritionData(
      name: 'Peanut Butter',
      brand: 'Natural',
      calories: 188,
      servingSize: '2',
      servingUnit: 'tablespoons',
      protein: 8,
      carbs: 7,
      fat: 16,
      fiber: 2,
      sugar: 3,
    ),
    NutritionData(
      name: 'White Rice',
      calories: 130,
      servingSize: '100',
      servingUnit: 'grams cooked',
      protein: 2.7,
      carbs: 28,
      fat: 0.3,
      fiber: 0.4,
      sugar: 0.1,
    ),
    NutritionData(
      name: 'Turkey Breast',
      calories: 135,
      servingSize: '100',
      servingUnit: 'grams',
      protein: 30,
      carbs: 0,
      fat: 1,
      fiber: 0,
      sugar: 0,
    ),
    NutritionData(
      name: 'Cottage Cheese',
      brand: 'Low Fat',
      calories: 81,
      servingSize: '100',
      servingUnit: 'grams',
      protein: 14,
      carbs: 3.4,
      fat: 1,
      fiber: 0,
      sugar: 3.4,
    ),
    NutritionData(
      name: 'Strawberries',
      calories: 49,
      servingSize: '1',
      servingUnit: 'cup',
      protein: 1,
      carbs: 12,
      fat: 0.5,
      fiber: 3,
      sugar: 7,
    ),
    NutritionData(
      name: 'Pasta',
      brand: 'Whole Wheat',
      calories: 174,
      servingSize: '100',
      servingUnit: 'grams cooked',
      protein: 7.5,
      carbs: 37,
      fat: 0.9,
      fiber: 6.3,
      sugar: 2.7,
    ),
    NutritionData(
      name: 'Beef',
      brand: 'Ground 90/10',
      calories: 176,
      servingSize: '100',
      servingUnit: 'grams',
      protein: 20,
      carbs: 0,
      fat: 10,
      fiber: 0,
      sugar: 0,
    ),
    NutritionData(
      name: 'Carrots',
      calories: 41,
      servingSize: '1',
      servingUnit: 'cup',
      protein: 0.9,
      carbs: 10,
      fat: 0.2,
      fiber: 2.8,
      sugar: 4.7,
    ),
    NutritionData(
      name: 'Milk',
      brand: '2% Fat',
      calories: 122,
      servingSize: '1',
      servingUnit: 'cup',
      protein: 8,
      carbs: 12,
      fat: 5,
      fiber: 0,
      sugar: 12,
    ),
    NutritionData(
      name: 'Orange',
      calories: 62,
      servingSize: '1',
      servingUnit: 'medium',
      protein: 1.2,
      carbs: 15,
      fat: 0.2,
      fiber: 3.1,
      sugar: 12,
    ),
    NutritionData(
      name: 'Cheese',
      brand: 'Cheddar',
      calories: 114,
      servingSize: '28',
      servingUnit: 'grams',
      protein: 7,
      carbs: 1,
      fat: 9,
      fiber: 0,
      sugar: 0,
    ),
    NutritionData(
      name: 'Protein Powder',
      brand: 'Whey',
      calories: 120,
      servingSize: '1',
      servingUnit: 'scoop (30g)',
      protein: 24,
      carbs: 3,
      fat: 1.5,
      fiber: 1,
      sugar: 2,
    ),
    NutritionData(
      name: 'Pizza',
      brand: 'Cheese',
      calories: 266,
      servingSize: '1',
      servingUnit: 'slice',
      protein: 11,
      carbs: 33,
      fat: 10,
      fiber: 2,
      sugar: 4,
    ),
  ];

  static Future<List<SearchResult>> searchFood(String query) async {
    try {
      // For demo purposes, we'll use the mock database
      // In production, replace this with actual Google Nutrition API calls

      final filteredResults = _mockFoodDatabase
          .where((food) =>
              food.name.toLowerCase().contains(query.toLowerCase()) ||
              (food.brand?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
          .map((food) => SearchResult(
                id: '${food.name.toLowerCase().replaceAll(' ', '-')}-${DateTime.now().millisecondsSinceEpoch}',
                name: food.name,
                brand: food.brand,
                calories: food.calories,
                servingSize: food.servingSize,
                servingUnit: food.servingUnit,
                protein: food.protein,
                carbs: food.carbs,
                fat: food.fat,
                fiber: food.fiber,
                sugar: food.sugar,
                sodium: food.sodium,
                image: food.image,
                barcode: food.barcode,
                confidence: _calculateConfidence(food.name, query),
              ))
          .toList()
        ..sort((a, b) => b.confidence.compareTo(a.confidence));

      final results = filteredResults.take(10).toList();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      return results;
    } catch (error) {
      debugPrint('Error searching for food: $error');
      throw Exception('Failed to search for food items');
    }
  }

  static Future<NutritionData?> getFoodByBarcode(String barcode) async {
    try {
      // Mock barcode lookup - replace with real API call
      final mockBarcodeData = {
        '1234567890': NutritionData(
          name: 'Coca Cola',
          brand: 'Coca-Cola',
          calories: 140,
          servingSize: '355',
          servingUnit: 'ml can',
          protein: 0,
          carbs: 39,
          fat: 0,
          sugar: 39,
          barcode: '1234567890',
        ),
      };

      await Future.delayed(const Duration(milliseconds: 300));
      return mockBarcodeData[barcode];
    } catch (error) {
      debugPrint('Error looking up barcode: $error');
      return null;
    }
  }

  static Future<NutritionData?> getDetailedNutrition(String foodId) async {
    try {
      // In production, this would fetch detailed nutrition info from Google's API
      final food = _mockFoodDatabase.firstWhere(
        (f) =>
            f.name.toLowerCase().replaceAll(' ', '-') == foodId.split('-')[0],
        orElse: () => throw Exception('Food not found'),
      );

      await Future.delayed(const Duration(milliseconds: 200));
      return food;
    } catch (error) {
      debugPrint('Error getting detailed nutrition: $error');
      return null;
    }
  }

  static double _calculateConfidence(String foodName, String query) {
    final food = foodName.toLowerCase();
    final search = query.toLowerCase();

    if (food == search) return 1.0;
    if (food.startsWith(search)) return 0.9;
    if (food.contains(search)) return 0.7;

    // Calculate similarity based on word matches
    final foodWords = food.split(' ');
    final searchWords = search.split(' ');
    final matches = searchWords
        .where((word) => foodWords.any((foodWord) => foodWord.contains(word)))
        .length;

    return matches / searchWords.length * 0.6;
  }

  static List<String> getNutritionRecommendations(String goal) {
    const recommendations = {
      'weight_loss': [
        'Focus on high-protein, low-calorie foods',
        'Include plenty of vegetables and fruits',
        'Choose lean proteins like chicken breast and fish',
        'Opt for whole grains over refined carbs',
      ],
      'muscle_gain': [
        'Increase protein intake to 1.6-2.2g per kg body weight',
        'Include complex carbohydrates for energy',
        'Add healthy fats like nuts and avocados',
        'Consider post-workout protein within 30 minutes',
      ],
      'maintenance': [
        'Maintain a balanced diet with all macronutrients',
        'Include a variety of colorful fruits and vegetables',
        'Stay hydrated with 8-10 glasses of water daily',
        'Practice portion control and mindful eating',
      ],
    };

    return recommendations[goal] ?? recommendations['maintenance']!;
  }
}
