import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/models/user_profile.dart';
import 'package:nutricalc/providers/profile_provider.dart';

class NutritionData {
  final double bmi;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final double water;
  final int fiber;
  final int sodium;
  final int potassium;
  final int calcium;
  final int iron;
  final int vitaminD;

  NutritionData({
    required this.bmi,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.water,
    required this.fiber,
    required this.sodium,
    required this.potassium,
    required this.calcium,
    required this.iron,
    required this.vitaminD,
  });
}

final nutritionDataProvider = FutureProvider.family<NutritionData, String>((ref, profileName) async {
  final profiles = await ref.watch(profileListProvider.future);
  final userProfile = profiles.firstWhere((p) => p.name == profileName);
  
  return _calculateNutrition(userProfile);
});

NutritionData _calculateNutrition(UserProfile profile) {
  final double heightInMeters = profile.height / 100;
  final double bmi = profile.weight / (heightInMeters * heightInMeters);

  double bmr;
  if (profile.sex == Sex.male) {
    bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age + 5;
  } else {
    bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age - 161;
  }

  final activityMultipliers = {
    ActivityLevel.sedentary: 1.2,
    ActivityLevel.light: 1.375,
    ActivityLevel.moderate: 1.55,
    ActivityLevel.active: 1.725,
    ActivityLevel.veryActive: 1.9,
  };
  final double tdee = bmr * activityMultipliers[profile.activityLevel]!;

  double targetCalories;
  switch (profile.goal) {
    case Goal.lose: targetCalories = tdee - 500; break;
    case Goal.maintain: targetCalories = tdee; break;
    case Goal.gain: targetCalories = tdee + 300; break;
  }

  double proteinGrams = (profile.goal == Goal.gain) ? profile.weight * 1.8 : profile.weight * 1.4;
  final double proteinCalories = proteinGrams * 4;
  final double fatCalories = targetCalories * 0.25;
  final double fatGrams = fatCalories / 9;
  final double carbCalories = targetCalories - proteinCalories - fatCalories;
  final double carbGrams = carbCalories / 4;

  final double water = profile.weight * 0.033;
  const int fiber = 30;
  const int sodium = 2300;
  final int potassium = profile.sex == Sex.male ? 3400 : 2600;
  final int calcium = 1000;
  final int iron = profile.sex == Sex.male ? 8 : 18;
  const int vitaminD = 600;

  return NutritionData(
    bmi: bmi,
    calories: targetCalories.round(),
    protein: proteinGrams.round(),
    carbs: carbGrams.round(),
    fat: fatGrams.round(),
    water: water,
    fiber: fiber,
    sodium: sodium,
    potassium: potassium,
    calcium: calcium,
    iron: iron,
    vitaminD: vitaminD,
  );
}