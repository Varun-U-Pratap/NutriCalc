import 'package:flutter/material.dart';
import 'dart:math';

class CalorieProgressCard extends StatefulWidget {
  final double goal;
  final double consumed;

  const CalorieProgressCard({
    super.key,
    required this.goal,
    required this.consumed,
  });

  @override
  State<CalorieProgressCard> createState() => _CalorieProgressCardState();
}

class _CalorieProgressCardState extends State<CalorieProgressCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- ANIMATION IS HERE: Using TweenAnimationBuilder to animate the 'consumed' value ---
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: widget.consumed),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOutCubic,
      builder: (context, animatedConsumed, child) {
        final remaining = max(0, widget.goal - animatedConsumed);
        final progress = (widget.goal > 0) ? min(1.0, animatedConsumed / widget.goal) : 0.0;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCalorieColumn("Goal", widget.goal.round(), theme),
                    _buildCalorieColumn("Consumed", animatedConsumed.round(), theme),
                    _buildCalorieColumn("Remaining", remaining.round(), theme, color: theme.colorScheme.primary),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress, // Animate the progress bar value
                    minHeight: 12,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    // ------------------------------------------------------------------------------------
  }

  Widget _buildCalorieColumn(String label, int value, ThemeData theme, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
