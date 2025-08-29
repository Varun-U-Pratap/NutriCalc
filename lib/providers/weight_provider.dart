import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/models/weight_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This provider will manage the list of weight entries for a given profile name.
final weightProvider = StateNotifierProvider.family<WeightNotifier, List<WeightEntry>, String>((ref, profileName) {
  return WeightNotifier(profileName);
});

class WeightNotifier extends StateNotifier<List<WeightEntry>> {
  final String profileName;
  late final String _storageKey;

  WeightNotifier(this.profileName) : super([]) {
    _storageKey = 'weightLog_$profileName';
    _loadWeightLog();
  }

  Future<void> _loadWeightLog() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      state = jsonList.map((json) => WeightEntry.fromJson(json)).toList();
    }
  }

  Future<void> _saveWeightLog() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> addWeightEntry(double weight) async {
    final newEntry = WeightEntry(date: DateTime.now(), weight: weight);
    
    // Replace today's entry if it already exists, otherwise add a new one.
    state = [
      ...state.where((entry) {
        final now = DateTime.now();
        return !(entry.date.year == now.year && entry.date.month == now.month && entry.date.day == now.day);
      }),
      newEntry,
    ];

    // Sort entries by date to keep the log clean
    state.sort((a, b) => a.date.compareTo(b.date));
    
    await _saveWeightLog();
  }
}
