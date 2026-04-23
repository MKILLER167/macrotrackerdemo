import 'package:flutter/material.dart';
import 'quick_add_food_dialog.dart';
import '../models/nutrition_model.dart';

class QuickAddFoodButton extends StatelessWidget {
  final Function(MealEntry)? onFoodAdded;
  final Function(int, String)? onXPGain;
  final String languageCode;

  const QuickAddFoodButton({
    super.key,
    this.onFoodAdded,
    this.onXPGain,
    this.languageCode = 'en',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => QuickAddFoodDialog(
              onFoodAdded: onFoodAdded,
              onXPGain: onXPGain,
              languageCode: languageCode,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(
          languageCode == 'ar' ? 'إضافة طعام' : 'Add Food',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
