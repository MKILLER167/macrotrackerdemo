import 'user_model.dart';

class DietPlan {
  final DietPlanType type;
  final String nameEn;
  final String nameAr;
  final String descEn;
  final String descAr;
  final double carbRatio;
  final double proteinRatio;
  final double fatRatio;

  const DietPlan({
    required this.type,
    required this.nameEn,
    required this.nameAr,
    required this.descEn,
    required this.descAr,
    required this.carbRatio,
    required this.proteinRatio,
    required this.fatRatio,
  });
}

class DietPlanService {
  static const List<DietPlan> standardPlans = [
    DietPlan(
      type: DietPlanType.standard,
      nameEn: 'Standard Balanced',
      nameAr: 'نظام متوازن',
      descEn:
          'A balanced diet for maintaining weight with consistent energy levels.',
      descAr: 'نظام غذائي متوازن للحفاظ على الوزن بمستويات طاقة ثابتة.',
      carbRatio: 0.50,
      proteinRatio: 0.20,
      fatRatio: 0.30,
    ),
    DietPlan(
      type: DietPlanType.keto,
      nameEn: 'Keto Diet',
      nameAr: 'حمية الكيتو',
      descEn: 'Low carbs and high fats to bring your body into ketosis.',
      descAr: 'كربوهيدرات منخفضة ودهون عالية لإدخال جسمك في حالة الكيتوزيس.',
      carbRatio: 0.05,
      proteinRatio: 0.25,
      fatRatio: 0.70,
    ),
    DietPlan(
      type: DietPlanType.intermittentFasting,
      nameEn: 'Intermittent Fasting',
      nameAr: 'الصيام المتقطع',
      descEn: 'Cycle between fasting and eating windows to improve metabolism.',
      descAr: 'دورة بين فترات الصيام والأكل لتحسين عملية الأيض.',
      carbRatio: 0.45,
      proteinRatio: 0.30,
      fatRatio: 0.25,
    ),
    DietPlan(
      type: DietPlanType.highProtein,
      nameEn: 'High Protein',
      nameAr: 'عالي البروتين',
      descEn: 'Maximize muscle retention and feel fuller for longer.',
      descAr: 'المحافظة على العضلات والشعور بالشبع لفترة أطول.',
      carbRatio: 0.40,
      proteinRatio: 0.40,
      fatRatio: 0.20,
    ),
    DietPlan(
      type: DietPlanType.vegan,
      nameEn: 'Plant Based (Vegan)',
      nameAr: 'نظام نباتي',
      descEn: 'Wholesome nutrition derived entirely from plant-based sources.',
      descAr: 'تغذية صحية مستمدة بالكامل من مصادر نباتية.',
      carbRatio: 0.55,
      proteinRatio: 0.20,
      fatRatio: 0.25,
    ),
  ];

  static DietPlan getPlan(DietPlanType type) {
    return standardPlans.firstWhere((p) => p.type == type,
        orElse: () => standardPlans.first);
  }
}
