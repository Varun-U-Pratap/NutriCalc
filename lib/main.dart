import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/constants/api_constants.dart';
import 'package:nutricalc/providers/theme_provider.dart';
import 'package:nutricalc/screens/profile_selection_screen.dart';
import 'package:nutricalc/screens/onboarding_screen.dart';
import 'package:nutricalc/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- FIX IS HERE: Ensures keys are loaded before proceeding ---
  await ApiConstants.init();
  // -----------------------------------------------------------

  final prefs = await SharedPreferences.getInstance();
  final profilesJson = prefs.getString('userProfiles');
  final bool hasProfiles = profilesJson != null && jsonDecode(profilesJson).isNotEmpty;

  runApp(
    ProviderScope(
      child: NutriCalcApp(hasProfiles: hasProfiles),
    ),
  );
}

class NutriCalcApp extends ConsumerWidget {
  final bool hasProfiles;
  const NutriCalcApp({super.key, required this.hasProfiles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'NutriCalc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: hasProfiles ? const ProfileSelectionScreen() : const OnboardingScreen(),
    );
  }
}
