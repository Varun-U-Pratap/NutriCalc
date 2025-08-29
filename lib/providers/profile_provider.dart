// lib/providers/profile_provider.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Profile List Provider ---
final profileListProvider = AsyncNotifierProvider<ProfileListNotifier, List<UserProfile>>(() {
  return ProfileListNotifier();
});

class ProfileListNotifier extends AsyncNotifier<List<UserProfile>> {
  Future<void> _save(List<UserProfile> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await prefs.setString('userProfiles', jsonString);
  }

  @override
  Future<List<UserProfile>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userProfiles') ?? '[]';
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => UserProfile.fromJson(json)).toList();
  }

  Future<bool> addProfile(UserProfile profile) async {
    final previousState = await future;
    if (previousState.any((p) => p.name.toLowerCase() == profile.name.toLowerCase())) {
      return false; // Profile with same name exists
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedList = [...previousState, profile];
      await _save(updatedList);
      return updatedList;
    });
    return !state.hasError;
  }

  Future<void> deleteProfile(String name) async {
    final previousState = await future;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedList = previousState.where((p) => p.name != name).toList();
      await _save(updatedList);
      return updatedList;
    });
  }
}

// --- Active Profile Provider ---
final activeProfileProvider = AsyncNotifierProvider<ActiveProfileNotifier, UserProfile?>(() {
  return ActiveProfileNotifier();
});

class ActiveProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final activeProfileName = prefs.getString('activeProfileName');
    if (activeProfileName == null) {
      return null;
    }
    
    // Watch the other provider to get the list of profiles
    final allProfiles = ref.watch(profileListProvider).valueOrNull ?? [];
    try {
      // Find the active profile in the list
      return allProfiles.firstWhere((p) => p.name == activeProfileName);
    } catch (e) {
      // This happens if the active profile was deleted.
      await clearActiveProfile();
      return null;
    }
  }

  Future<void> setActiveProfile(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('activeProfileName', name);
    // Invalidate self to re-run the build method with the new name
    ref.invalidateSelf();
    await future;
  }
    
  Future<void> clearActiveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('activeProfileName');
    ref.invalidateSelf();
    await future;
  }
}