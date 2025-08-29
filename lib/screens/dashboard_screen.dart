// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/models/diet_plan.dart';
import 'package:nutricalc/providers/diet_plan_provider.dart';
import 'package:nutricalc/providers/tip_provider.dart';
import 'package:nutricalc/screens/daily_log_screen.dart';
import 'package:nutricalc/screens/food_search_screen.dart';
import 'package:nutricalc/providers/nutrition_provider.dart';
import 'package:nutricalc/providers/food_log_provider.dart';
import 'package:nutricalc/providers/profile_provider.dart';
import 'package:nutricalc/widgets/animated_list_item.dart';
import 'package:nutricalc/widgets/bmi_gauge.dart';
import 'package:nutricalc/widgets/diet_plan_shimmer.dart'; // Import the new shimmer widget
import 'package:nutricalc/widgets/macro_pie_chart.dart';
import 'package:nutricalc/widgets/app_drawer.dart';
import 'package:nutricalc/widgets/calorie_progress_card.dart';
import 'package:nutricalc/widgets/nutrient_grid_item.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfileAsync = ref.watch(activeProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(activeProfileAsync.valueOrNull?.name ?? "Dashboard"),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const FoodSearchScreen(),
              transitionsBuilder: (_, animation, __, child) => SlideTransition(
                position: Tween(begin: const Offset(0,1), end: Offset.zero).animate(animation),
                child: child,
              ),
            )
          );
        },
        child: const Icon(Icons.add),
      ),
      body: activeProfileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text("Please select a profile from the drawer."));
          }
          final nutritionState = ref.watch(nutritionDataProvider(profile.name));
          final todayTotals = ref.watch(todayTotalsProvider(profile.name));

          return nutritionState.when(
            data: (data) => _buildDashboardContent(context, data, todayTotals, ref),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text("Error loading plan:\n$err")),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error loading profile:\n$err")),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, NutritionData data, Map<String, double> todayTotals, WidgetRef ref) {
    final activeProfileName = ref.watch(activeProfileProvider).value!.name;
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(tipOfTheDayProvider);
        ref.invalidate(nutritionDataProvider(activeProfileName));
        ref.invalidate(foodLogProvider(activeProfileName));
        ref.invalidate(dietPlanProvider(data));
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          const _TipOfTheDayCard(),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.orangeAccent),
              title: const Text("Daily Food Log"),
              subtitle: const Text("View or remove logged items"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyLogScreen()));
              },
            ),
          ),
          const SizedBox(height: 24),
          BmiGauge(bmi: data.bmi),
          const SizedBox(height: 24),
          CalorieProgressCard(
            goal: data.calories.toDouble(),
            consumed: todayTotals['calories']!,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Macronutrients", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: MacroPieChart(
                      proteinGoal: data.protein.toDouble(),
                      carbsGoal: data.carbs.toDouble(),
                      fatGoal: data.fat.toDouble(),
                      proteinConsumed: todayTotals['protein']!,
                      carbsConsumed: todayTotals['carbs']!,
                      fatConsumed: todayTotals['fat']!,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text("Key Nutrients", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: List.generate(7, (index) {
              final nutrientData = [
                {'icon': 'assets/icons/water.svg', 'name': 'Water', 'value': '${data.water.toStringAsFixed(1)} L'},
                {'icon': 'assets/icons/fiber.svg', 'name': 'Fiber', 'value': '${data.fiber} g'},
                {'icon': 'assets/icons/sodium.svg', 'name': 'Sodium', 'value': '< ${data.sodium} mg'},
                {'icon': 'assets/icons/potassium.svg', 'name': 'Potassium', 'value': '~ ${data.potassium} mg'},
                {'icon': 'assets/icons/calcium.svg', 'name': 'Calcium', 'value': '~ ${data.calcium} mg'},
                {'icon': 'assets/icons/iron.svg', 'name': 'Iron', 'value': '~ ${data.iron} mg'},
                {'icon': 'assets/icons/vitamin-d.svg', 'name': 'Vitamin D', 'value': '~ ${data.vitaminD} IU'},
              ];

              return AnimatedListItem(
                index: index,
                child: NutrientGridItem(
                  iconPath: nutrientData[index]['icon']!,
                  name: nutrientData[index]['name']!,
                  value: nutrientData[index]['value']!,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("7-Day Diet Plan", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.invalidate(dietPlanProvider(data)),
                tooltip: "Regenerate Plan",
              )
            ],
          ),
          const SizedBox(height: 16),
          _DietPlanSection(nutritionData: data),
        ],
      ),
    );
  }
}

class _TipOfTheDayCard extends ConsumerWidget {
  const _TipOfTheDayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipAsync = ref.watch(tipOfTheDayProvider);
    final theme = Theme.of(context);

    return tipAsync.when(
      data: (tip) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Card(
            color: theme.colorScheme.primaryContainer.withOpacity(0.7),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       Icon(Icons.lightbulb_outline, color: theme.colorScheme.onPrimaryContainer),
                       const SizedBox(width: 8),
                       Text(
                        "Tip of the Day",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

class _DietPlanSection extends ConsumerStatefulWidget {
  final NutritionData nutritionData;
  const _DietPlanSection({required this.nutritionData});

  @override
  ConsumerState<_DietPlanSection> createState() => _DietPlanSectionState();
}

class _DietPlanSectionState extends ConsumerState<_DietPlanSection> {
  final List<bool> _isExpanded = List.generate(7, (_) => false);

  @override
  Widget build(BuildContext context) {
    final dietPlanAsync = ref.watch(dietPlanProvider(widget.nutritionData));

    return dietPlanAsync.when(
      data: (plan) {
        return Column(
          children: plan.weeklyPlan.asMap().entries.map((entry) {
            int index = entry.key;
            DailyPlan dailyPlan = entry.value;
            return _buildDayCard(context, dailyPlan, index);
          }).toList(),
        );
      },
      // --- FIX IS HERE: Replaced the old loading widget with the new shimmer effect ---
      loading: () => const DietPlanShimmer(),
      // -----------------------------------------------------------------------------
      error: (err, stack) {
        return Card(
          color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  "Oops! Something went wrong.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "We couldn't generate your diet plan. This may be due to a network issue or API quota limits. Please try again later.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(dietPlanProvider(widget.nutritionData)),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildDayCard(BuildContext context, DailyPlan dailyPlan, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            title: Text(dailyPlan.day, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(_isExpanded[index] ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded[index] = !_isExpanded[index];
                });
              },
            ),
            onTap: () {
               setState(() {
                  _isExpanded[index] = !_isExpanded[index];
                });
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: _isExpanded[index]
                ? Padding(
                    key: ValueKey<int>(index), 
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        const Divider(),
                        _buildMealTile(context, "Breakfast", dailyPlan.breakfast, Icons.breakfast_dining_outlined, Colors.amber),
                        const Divider(),
                        _buildMealTile(context, "Lunch", dailyPlan.lunch, Icons.lunch_dining_outlined, Colors.orange),
                        const Divider(),
                        _buildMealTile(context, "Dinner", dailyPlan.dinner, Icons.dinner_dining_outlined, Colors.red),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTile(BuildContext context, String title, Meal meal, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${meal.name}\n(${meal.description})"),
      isThreeLine: true,
      trailing: TextButton(
        child: const Text("Log"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FoodSearchScreen(initialQuery: meal.name),
            ),
          );
        },
      ),
    );
  }
}
