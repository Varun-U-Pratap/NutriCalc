import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MacroPieChart extends StatefulWidget {
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;
  final double proteinConsumed;
  final double carbsConsumed;
  final double fatConsumed;

  const MacroPieChart({
    super.key,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    required this.proteinConsumed,
    required this.carbsConsumed,
    required this.fatConsumed,
  });

  @override
  State<MacroPieChart> createState() => _MacroPieChartState();
}

// --- FIX IS HERE: Added SingleTickerProviderStateMixin for animation control ---
class _MacroPieChartState extends State<MacroPieChart> with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // --- FIX IS HERE: Wrapped the chart in an AnimatedBuilder ---
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Indicator(color: Colors.blueAccent, text: 'Protein', isSquare: false, value: "${widget.proteinConsumed.round()}/${widget.proteinGoal.round()}g"),
                const SizedBox(height: 4),
                _Indicator(color: Colors.amber, text: 'Carbs', isSquare: false, value: "${widget.carbsConsumed.round()}/${widget.carbsGoal.round()}g"),
                const SizedBox(height: 4),
                _Indicator(color: Colors.pinkAccent, text: 'Fat', isSquare: false, value: "${widget.fatConsumed.round()}/${widget.fatGoal.round()}g"),
              ],
            ),
          ],
        );
      },
    );
    // -------------------------------------------------------------
  }

  List<PieChartSectionData> showingSections() {
    final totalGoal = widget.proteinGoal + widget.carbsGoal + widget.fatGoal;
    if (totalGoal == 0) return [];

    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      
      switch (i) {
        case 0: // Protein
          return PieChartSectionData(
            color: Colors.blueAccent,
            value: widget.proteinGoal,
            title: '${(widget.proteinGoal / totalGoal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: _buildBadge(widget.proteinConsumed, widget.proteinGoal, _animation.value),
            badgePositionPercentageOffset: .98,
          );
        case 1: // Carbs
          return PieChartSectionData(
            color: Colors.amber,
            value: widget.carbsGoal,
            title: '${(widget.carbsGoal / totalGoal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: _buildBadge(widget.carbsConsumed, widget.carbsGoal, _animation.value),
            badgePositionPercentageOffset: .98,
          );
        case 2: // Fat
          return PieChartSectionData(
            color: Colors.pinkAccent,
            value: widget.fatGoal,
            title: '${(widget.fatGoal / totalGoal * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: _buildBadge(widget.fatConsumed, widget.fatGoal, _animation.value),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Error();
      }
    });
  }

  // --- FIX IS HERE: The badge now uses the animation value to calculate the percentage ---
  Widget _buildBadge(double consumed, double goal, double animationValue) {
    if (consumed == 0 || goal == 0) return const SizedBox.shrink();
    // Animate the consumed value from 0 to its final amount
    final animatedConsumed = consumed * animationValue;
    final percentage = min(1.0, animatedConsumed / goal);
    return CircleAvatar(
      radius: 12,
      backgroundColor: Colors.white.withOpacity(0.8),
      child: Text(
        '${(percentage * 100).toInt()}%',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
  // ------------------------------------------------------------------------------------
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final String value;
  final bool isSquare;
  final double size;

  const _Indicator({
    required this.color,
    required this.text,
    required this.value,
    this.isSquare = true,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7))),
          ],
        )
      ],
    );
  }
}
