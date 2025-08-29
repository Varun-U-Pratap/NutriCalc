import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_log_entry.dart';

// This provider now holds ALL food log entries across all dates.
final foodLogProvider = StateNotifierProvider.family<FoodLogNotifier, List<FoodLogEntry>, String>((ref, profileName) {
  return FoodLogNotifier(profileName);
});

class FoodLogNotifier extends StateNotifier<List<FoodLogEntry>> {
  final String profileName;
  late final String _storageKey;

  FoodLogNotifier(this.profileName) : super([]) {
    _storageKey = 'foodLog_$profileName';
    _loadLog();
  }
  
  Future<void> addFood(FoodLogEntry entry) async {
    state = [...state, entry];
    await _saveLog();
  }

  Future<void> removeFood(String foodId, DateTime loggedAt) async {
    state = state.where((entry) => !(entry.foodId == foodId && entry.loggedAt == loggedAt)).toList();
    await _saveLog();
  }

  Future<void> _loadLog() async {
    final prefs = await SharedPreferences.getInstance();
    final logJson = prefs.getString(_storageKey);
    if (logJson != null) {
      final List<dynamic> decoded = jsonDecode(logJson);
      // --- CHANGE IS HERE: Load all entries, not just today's ---
      final entries = decoded.map((item) => FoodLogEntry.fromJson(item)).toList();
      state = entries;
      // -----------------------------------------------------------
    }
  }

  Future<void> _saveLog() async {
    final prefs = await SharedPreferences.getInstance();
    final logJson = jsonEncode(state.map((entry) => entry.toJson()).toList());
    await prefs.setString(_storageKey, logJson);
  }
}

// This provider derives its state from the main log, filtering for today.
final todayLogProvider = Provider.family<List<FoodLogEntry>, String>((ref, profileName) {
  final allEntries = ref.watch(foodLogProvider(profileName));
  final now = DateTime.now();
  
  return allEntries.where((entry) => 
    entry.loggedAt.year == now.year &&
    entry.loggedAt.month == now.month &&
    entry.loggedAt.day == now.day
  ).toList();
});


// This provider calculates totals, but now it only uses today's log.
final todayTotalsProvider = Provider.family<Map<String, double>, String>((ref, profileName) {
  // --- CHANGE IS HERE: Watch the new todayLogProvider ---
  final log = ref.watch(todayLogProvider(profileName));
  // ----------------------------------------------------
  double totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFat = 0;

  for (var entry in log) {
    totalCalories += entry.calories;
    totalProtein += entry.protein;
    totalCarbs += entry.carbs;
    totalFat += entry.fat;
  }

  return {
    'calories': totalCalories,
    'protein': totalProtein,
    'carbs': totalCarbs,
    'fat': totalFat,
  };
});
