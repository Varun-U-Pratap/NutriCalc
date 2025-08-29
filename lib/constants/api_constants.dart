import 'package:shared_preferences/shared_preferences.dart';

class ApiConstants {
  // --- EDAMAM API FOR FOOD SEARCH ---
  static String appId = '542919f1';
  static String appKey = '5b9e73c9860bacce1b885c1d78d5d435';
  static const String baseUrl = 'https://api.edamam.com/api/food-database/v2/parser';
  
  // --- GEMINI API FOR DIET PLAN, TIP, & CHATBOT ---
  static String geminiApiKey = 'AIzaSyD4HqfGTZknQdf-7xtUFnHQq1XGXwGyxRg';
  static const String geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    appId = prefs.getString('edamamAppId') ?? appId;
    appKey = prefs.getString('edamamAppKey') ?? appKey;
    geminiApiKey = prefs.getString('geminiApiKey') ?? geminiApiKey;
  }

  static Future<void> saveEdamamKeys(String newAppId, String newAppKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('edamamAppId', newAppId);
    await prefs.setString('edamamAppKey', newAppKey);
    appId = newAppId;
    appKey = newAppKey;
  }

  static Future<void> saveGeminiKey(String newApiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('geminiApiKey', newApiKey);
    geminiApiKey = newApiKey;
  }
}
