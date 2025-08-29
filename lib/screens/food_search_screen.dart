import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/models/food_log_entry.dart';
import 'package:nutricalc/providers/food_log_provider.dart';
import 'package:nutricalc/providers/profile_provider.dart';
import 'package:nutricalc/services/food_api_service.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  // --- FIX IS HERE: Added initialQuery to the constructor ---
  final String? initialQuery;
  const FoodSearchScreen({super.key, this.initialQuery});
  // ---------------------------------------------------------

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _searchController = TextEditingController();
  final FoodApiService _apiService = FoodApiService();
  Future<List<dynamic>>? _searchResults;
  bool _isLoading = false;

  // --- FIX IS HERE: New initState to handle the initial query ---
  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      // Use addPostFrameCallback to ensure the search runs after the first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearchWithQuery(widget.initialQuery!);
      });
    }
  }
  // -------------------------------------------------------------

  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      _performSearchWithQuery(_searchController.text);
    }
  }

  // --- FIX IS HERE: Extracted search logic into its own method ---
  void _performSearchWithQuery(String query) {
    setState(() {
      _isLoading = true;
      _searchResults = _apiService.searchFood(query);
    });
    _searchResults!.whenComplete(() => setState(() => _isLoading = false));
  }
  // --------------------------------------------------------------

  void _logFood(dynamic foodData) {
    HapticFeedback.lightImpact();

    final activeProfileName = ref.read(activeProfileProvider).value?.name;
    if (activeProfileName == null) return;

    final food = foodData['food'];
    final nutrients = food['nutrients'];

    final entry = FoodLogEntry(
      foodId: food['foodId'],
      label: food['label'],
      calories: (nutrients['ENERC_KCAL'] ?? 0.0).toDouble(),
      protein: (nutrients['PROCNT'] ?? 0.0).toDouble(),
      carbs: (nutrients['CHOCDF'] ?? 0.0).toDouble(),
      fat: (nutrients['FAT'] ?? 0.0).toDouble(),
      loggedAt: DateTime.now(),
    );

    ref.read(foodLogProvider(activeProfileName).notifier).addFood(entry);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${entry.label} logged!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Food'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a food...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && _searchResults != null) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(widget.initialQuery != null ? 'Searching...' : 'No results. Try searching for a food.'));
                  }

                  final results = snapshot.data!;
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final foodItem = results[index]['food'];
                      final nutrients = foodItem['nutrients'];
                      return ListTile(
                        title: Text(foodItem['label']),
                        subtitle: Text('${(nutrients['ENERC_KCAL'] ?? 0.0).toStringAsFixed(0)} kcal, 100g'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onPressed: () => _logFood(results[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
