import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:nutricalc/models/food_log_entry.dart';
import 'package:nutricalc/models/weight_entry.dart';
import 'package:nutricalc/providers/food_log_provider.dart';
import 'package:nutricalc/providers/profile_provider.dart';
import 'package:nutricalc/providers/weight_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfileName = ref.watch(activeProfileProvider).value?.name;

    if (activeProfileName == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Reports")),
        body: const Center(child: Text("Please select a profile.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports & History"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _WeightTrackingCard(profileName: activeProfileName),
          const SizedBox(height: 24),
          _CalorieHistoryCard(profileName: activeProfileName),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWeightDialog(context, ref, activeProfileName),
        label: const Text("Log Weight"),
        icon: const Icon(Icons.monitor_weight_outlined),
      ),
    );
  }

  void _showAddWeightDialog(BuildContext context, WidgetRef ref, String profileName) {
    final weightController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log Today's Weight"),
          content: TextField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Weight (kg)",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final weight = double.tryParse(weightController.text);
                if (weight != null) {
                  ref.read(weightProvider(profileName).notifier).addWeightEntry(weight);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

// --- WEIGHT TRACKING WIDGET ---
class _WeightTrackingCard extends ConsumerWidget {
  final String profileName;
  const _WeightTrackingCard({required this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightEntries = ref.watch(weightProvider(profileName));
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weight History", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (weightEntries.length < 2)
              const Center(child: Text("Log weight for at least 2 days to see a chart."))
            else
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: weightEntries.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.weight)).toList(),
                        isCurved: true,
                        color: theme.colorScheme.primary,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- CALORIE HISTORY WIDGET ---
class _CalorieHistoryCard extends ConsumerWidget {
  final String profileName;
  const _CalorieHistoryCard({required this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allFoodEntries = ref.watch(foodLogProvider(profileName));
    final theme = Theme.of(context);
    final weeklyData = _prepareWeeklyCalorieData(allFoodEntries);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Last 7 Days - Calories", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (weeklyData.isEmpty)
              const Center(child: Text("No food logged in the last 7 days."))
            else
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            weeklyData[value.toInt()].day,
                            style: const TextStyle(fontSize: 12),
                          ),
                          reservedSize: 20,
                        ),
                      ),
                    ),
                    barGroups: weeklyData.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.calories,
                            color: theme.colorScheme.primary,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<_ChartData> _prepareWeeklyCalorieData(List<FoodLogEntry> entries) {
    Map<String, double> dailyTotals = {};
    final today = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dayKey = DateFormat('yyyy-MM-dd').format(date);
      final dayLabel = DateFormat('E').format(date).substring(0,1); // 'M', 'T', 'W', etc.
      dailyTotals[dayKey] = 0;
    }

    for (var entry in entries) {
      final dayKey = DateFormat('yyyy-MM-dd').format(entry.loggedAt);
      if (dailyTotals.containsKey(dayKey)) {
        dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + entry.calories;
      }
    }

    return dailyTotals.entries.map((e) => _ChartData(DateFormat('E').format(DateTime.parse(e.key)).substring(0,1), e.value)).toList();
  }
}

// Helper class for chart data
class _ChartData {
  final String day;
  final double calories;
  _ChartData(this.day, this.calories);
}
