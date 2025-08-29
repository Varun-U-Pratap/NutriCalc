import 'package:flutter/material.dart';

class BmiGauge extends StatefulWidget {
  final double bmi;

  const BmiGauge({super.key, required this.bmi});

  @override
  State<BmiGauge> createState() => _BmiGaugeState();
}

class _BmiGaugeState extends State<BmiGauge> {
  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Healthy";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- ANIMATION IS HERE: Using TweenAnimationBuilder to animate the BMI value ---
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: widget.bmi),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOutCubic,
      builder: (context, animatedBmi, child) {
        final category = _getBmiCategory(animatedBmi);
        final color = _getBmiColor(animatedBmi);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("Your BMI", style: theme.textTheme.titleMedium?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      animatedBmi.toStringAsFixed(1),
                      style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: color),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: color),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (animatedBmi - 15) / (35 - 15), // Animate the progress bar value
                    minHeight: 12,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("18.5"), Text("25"), Text("30")],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
    // --------------------------------------------------------------------------------
  }
}
