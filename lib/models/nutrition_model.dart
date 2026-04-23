enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

enum MealSource {
  search,
  custom,
  barcode,
  quick,
}

class MealEntry {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final MealType mealType;
  final DateTime timestamp;
  final MealSource source;
  final double amount;
  final String unit;
  final String? consumedAt; // Time when the meal was consumed (HH:mm format)

  MealEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealType,
    required this.timestamp,
    required this.source,
    this.amount = 1.0,
    this.unit = 'serving',
    this.consumedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'mealType': mealType.name,
      'timestamp': timestamp.toIso8601String(),
      'source': source.name,
      'amount': amount,
      'unit': unit,
      'consumedAt': consumedAt,
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'],
      name: json['name'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['mealType'],
        orElse: () => MealType.breakfast,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      source: MealSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => MealSource.custom,
      ),
      amount: json['amount']?.toDouble() ?? 1.0,
      unit: json['unit'] ?? 'serving',
      consumedAt: json['consumedAt'],
    );
  }
}

class QuickFood {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String unit;
  final String category;

  QuickFood({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.unit,
    required this.category,
  });
}

class NutritionData {
  final String name;
  final String? brand;
  final int calories;
  final String servingSize;
  final String servingUnit;
  final double protein;
  final double carbs;
  final double fat;
  final double? fiber;
  final double? sugar;
  final double? sodium;
  final String? image;
  final String? barcode;

  NutritionData({
    required this.name,
    this.brand,
    required this.calories,
    required this.servingSize,
    required this.servingUnit,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber,
    this.sugar,
    this.sodium,
    this.image,
    this.barcode,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'calories': calories,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'image': image,
      'barcode': barcode,
    };
  }
}

class SearchResult extends NutritionData {
  final String id;
  final String? description;
  final double confidence;

  SearchResult({
    required this.id,
    required super.name,
    super.brand,
    required super.calories,
    required super.servingSize,
    required super.servingUnit,
    required super.protein,
    required super.carbs,
    required super.fat,
    super.fiber,
    super.sugar,
    super.sodium,
    super.image,
    super.barcode,
    this.description,
    required this.confidence,
  });
}
