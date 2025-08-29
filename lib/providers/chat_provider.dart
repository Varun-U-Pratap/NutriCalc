import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nutricalc/constants/api_constants.dart';
import 'package:nutricalc/models/chat_message.dart';
import 'package:nutricalc/models/user_profile.dart';

// This provider will manage the state of the chat conversation.
final chatProvider = StateNotifierProvider.autoDispose<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]) {
    // Add the initial welcome message from the bot.
    state = [
      ChatMessage(
        text: "Hello! I'm Calix, your personal health assistant. How can I help you with your diet or workout plan today?",
        sender: MessageSender.bot,
      )
    ];
  }

  Future<void> sendMessage(String text, UserProfile userProfile) async {
    // Add the user's message to the chat list immediately.
    state = [...state, ChatMessage(text: text, sender: MessageSender.user)];

    try {
      // --- FIX IS HERE: Reverted to use the Gemini API ---
      if (ApiConstants.geminiApiKey == 'YOUR_GEMINI_API_KEY') {
        throw Exception('Gemini API key is not set.');
      }

      final url = Uri.parse('${ApiConstants.geminiApiBaseUrl}?key=${ApiConstants.geminiApiKey}');
      
      final prompt = """
      You are Calix, a friendly and encouraging health assistant. A user is asking for advice.
      Here is the user's profile:
      - Goal: ${userProfile.goal.toString().split('.').last}
      - Weight: ${userProfile.weight} kg
      - Height: ${userProfile.height} cm
      - Age: ${userProfile.age}
      - Sex: ${userProfile.sex.toString().split('.').last}
      - Activity Level: ${userProfile.activityLevel.toString().split('.').last}

      Based on their goal (${userProfile.goal.toString().split('.').last}), provide helpful, safe, and actionable advice in response to their question. Keep your answers concise and easy to understand.

      User's question: "$text"
      """;

      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'contents': [{'parts': [{'text': prompt}]}]});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['candidates'] == null || responseBody['candidates'].isEmpty) {
          throw Exception("The API returned no content.");
        }
        final botResponse = responseBody['candidates'][0]['content']['parts'][0]['text'].trim();
        state = [...state, ChatMessage(text: botResponse, sender: MessageSender.bot)];
      } else {
        throw Exception('API request failed: ${response.body}');
      }
      // ----------------------------------------------------
    } catch (e) {
      state = [...state, ChatMessage(text: "Sorry, I'm having trouble connecting right now. Please try again later.", sender: MessageSender.bot)];
    }
  }
}
