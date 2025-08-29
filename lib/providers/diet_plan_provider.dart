import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nutricalc/constants/api_constants.dart';
import 'package:nutricalc/models/diet_plan.dart';
import 'package:nutricalc/providers/nutrition_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- FIX IS HERE: Converted to a StateNotifierProvider for caching ---
final dietPlanProvider = StateNotifierProvider.autoDispose.family<DietPlanNotifier, AsyncValue<DietPlan>, NutritionData>((ref, nutritionData) {
  return DietPlanNotifier(nutritionData);
});

class DietPlanNotifier extends StateNotifier<AsyncValue<DietPlan>> {
  final NutritionData nutritionData;

  DietPlanNotifier(this.nutritionData) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedPlanJson = prefs.getString('cachedDietPlan');
    final cachedGoals = prefs.getString('cachedDietPlanGoals');

    // Create a simple string representation of the current goals to check against the cache.
    final currentGoals = "${nutritionData.calories}-${nutritionData.protein}-${nutritionData.carbs}-${nutritionData.fat}";

    // If we have a cached plan and the goals match, show it immediately.
    if (cachedPlanJson != null && cachedGoals == currentGoals) {
      try {
        final decodedPlan = DietPlan.fromJson(jsonDecode(cachedPlanJson));
        state = AsyncValue.data(decodedPlan);
        // No need to fetch a new one if goals are the same.
        return; 
      } catch (e) {
        // If parsing fails, proceed to fetch a new plan.
      }
    }

    // Fetch a new plan if we don't have one or if the user's goals have changed.
    await _fetchNewPlan();
  }

  Future<void> _fetchNewPlan() async {
    state = const AsyncValue.loading();

    try {
      if (ApiConstants.geminiApiKey == 'YOUR_GEMINI_API_KEY') {
        throw Exception('Gemini API key is not set.');
      }

      final url = Uri.parse('${ApiConstants.geminiApiBaseUrl}?key=${ApiConstants.geminiApiKey}');
      final prompt = """
      Create a 7-day Indian vegetarian diet plan for a person with the following daily nutritional goals:
      - Calories: ${nutritionData.calories.round()} kcal
      - Protein: ${nutritionData.protein.round()} g
      - Carbohydrates: ${nutritionData.carbs.round()} g
      - Fat: ${nutritionData.fat.round()} g

      Provide the response as a single, minified JSON object with no markdown formatting.
      The JSON object must follow this exact structure:
      {
        "weeklyPlan": [
          {"day": "Monday", "breakfast": {"name": "Dish Name", "description": "Brief description"}, "lunch": {"name": "Dish Name", "description": "Brief description"}, "dinner": {"name": "Dish Name", "description": "Brief description"}},
          {"day": "Tuesday", "breakfast": {"name": "Dish Name", "description": "Brief description"}, "lunch": {"name": "Dish Name", "description": "Brief description"}, "dinner": {"name": "Dish Name", "description": "Brief description"}},
          {"day": "Wednesday", "breakfast": {"name": "Dish Name", "description": "Brief description"}, "lunch": {"name": "Dish Name", "description": "Brief description"}, "dinner": {"name": "Dish Name", "description": "Brief description"}},
          {"day": "Thursday", "breakfast": {"name": "Dish Name", "description": "Brief description"}, "lunch": {"name": "Dish Name", "description": "Brief description"}, "dinner": {"name": "Dish Name", "description": "Brief description"}},
          {"day": "Friday", "breakfast": {"name": "Dish Name", "description": "Brief description"}, "lunch": {"name": "Dish Name", "description": "Brief description"}, "dinner": {"name": "Dish Name", "description": "Brief description"}},
          {"day": "Saturday", "breakfast": {"name": "Dish Name", "description": "Brief description"}, "lunch": {"name": "Dish Name", "description": "Brief description"}, "dinner": {"name": "Dish Name", "description": "Brief description"}},
          {"day": "Sunday", "breakfast": {"name": "Dish Name", "description": "Brief description"}, "lunch": {"name": "Dish Name", "description": "Brief description"}, "dinner": {"name": "Dish Name", "description": "Brief description"}}
        ]
      }
      """;

      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'contents': [{'parts': [{'text': prompt}]}]});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final jsonString = responseBody['candidates'][0]['content']['parts'][0]['text'];
        final Map<String, dynamic> dietPlanJson = jsonDecode(jsonString);
        final newPlan = DietPlan.fromJson(dietPlanJson);

        // Save the new plan and its associated goals to the cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cachedDietPlan', jsonString);
        final currentGoals = "${nutritionData.calories}-${nutritionData.protein}-${nutritionData.carbs}-${nutritionData.fat}";
        await prefs.setString('cachedDietPlanGoals', currentGoals);

        state = AsyncValue.data(newPlan);
      } else {
        throw Exception('Failed to generate diet plan: ${response.body}');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
