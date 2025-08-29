import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/providers/food_log_provider.dart';
import 'package:nutricalc/providers/profile_provider.dart';
import 'package:nutricalc/widgets/animated_list_item.dart'; // Import the new widget

class DailyLogScreen extends ConsumerWidget {
  const DailyLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfileName = ref.watch(activeProfileProvider).value?.name;

    if (activeProfileName == null) {
      return const Scaffold(body: Center(child: Text("No active profile.")));
    }
    
    final todaysLog = ref.watch(todayLogProvider(activeProfileName));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Log"),
      ),
      body: todaysLog.isEmpty
          ? const Center(
              child: Text(
                "No food logged for today.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: todaysLog.length,
              itemBuilder: (context, index) {
                final entry = todaysLog[index];
                // --- FIX IS HERE: Each Card is now wrapped in the animation widget ---
                return AnimatedListItem(
                  index: index,
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      title: Text(entry.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "${entry.calories.toStringAsFixed(0)} kcal | P:${entry.protein.toStringAsFixed(0)}g C:${entry.carbs.toStringAsFixed(0)}g F:${entry.fat.toStringAsFixed(0)}g",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ref.read(foodLogProvider(activeProfileName).notifier).removeFood(entry.foodId, entry.loggedAt);
                        },
                      ),
                    ),
                  ),
                );
                // --------------------------------------------------------------------
              },
            ),
    );
  }
}
