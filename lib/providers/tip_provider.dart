import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nutricalc/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- FIX IS HERE: Converted to a StateNotifierProvider for caching ---
final tipOfTheDayProvider = StateNotifierProvider.autoDispose<TipNotifier, AsyncValue<String>>((ref) {
  return TipNotifier();
});

class TipNotifier extends StateNotifier<AsyncValue<String>> {
  TipNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedTip = prefs.getString('cachedTip');
    final cachedDate = prefs.getString('cachedTipDate');
    final today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD

    // If we have a cached tip, show it immediately.
    if (cachedTip != null) {
      state = AsyncValue.data(cachedTip);
    }

    // Fetch a new tip if we don't have one or if it's a new day.
    if (cachedTip == null || cachedDate != today) {
      await _fetchNewTip();
    }
  }

  Future<void> _fetchNewTip() async {
    // If we already have data, don't show a loading screen for the background fetch.
    if (state is! AsyncData) {
      state = const AsyncValue.loading();
    }

    try {
      if (ApiConstants.geminiApiKey == 'YOUR_GEMINI_API_KEY') {
        throw Exception('Set your Gemini API key to get daily tips!');
      }

      final url = Uri.parse('${ApiConstants.geminiApiBaseUrl}?key=${ApiConstants.geminiApiKey}');
      const prompt = "Give me one short, insightful, and motivational health or nutrition tip. Make it concise and easy to understand. Do not include any introductory text like 'Here is a tip:'. Just provide the tip itself.";
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'contents': [{'parts': [{'text': prompt}]}],
        "safetySettings": [
            {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"},
            {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_ONLY_HIGH"},
            {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_ONLY_HIGH"},
            {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_ONLY_HIGH"}
        ]
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['candidates'] == null || responseBody['candidates'].isEmpty) {
          throw Exception("The API returned no content.");
        }
        final newTip = responseBody['candidates'][0]['content']['parts'][0]['text'].trim();
        
        // Save the new tip and date to cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cachedTip', newTip);
        await prefs.setString('cachedTipDate', DateTime.now().toIso8601String().substring(0, 10));

        state = AsyncValue.data(newTip);
      } else {
        throw Exception('Failed to get tip. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e, stack) {
      // If fetching fails but we have old data, keep showing the old data.
      if (state is! AsyncData) {
        state = AsyncValue.error(e, stack);
      }
    }
  }
}
