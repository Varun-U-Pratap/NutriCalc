import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class FoodApiService {
  Future<List<dynamic>> searchFood(String query) async {
    if (ApiConstants.appId == 'YOUR_APP_ID' || ApiConstants.appKey == 'YOUR_APP_KEY') {
        throw Exception('API credentials are not set in lib/constants/api_constants.dart');
    }
    
    final url = Uri.parse(
        '${ApiConstants.baseUrl}?app_id=${ApiConstants.appId}&app_key=${ApiConstants.appKey}&ingr=$query');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['hints'] as List<dynamic>;
      } else {
        throw Exception('Failed to load food data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the food service: $e');
    }
  }
}