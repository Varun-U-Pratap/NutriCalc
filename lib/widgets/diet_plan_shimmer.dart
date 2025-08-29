import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DietPlanShimmer extends StatelessWidget {
  const DietPlanShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColor = theme.brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[300]!;
    final shimmerHighlightColor = theme.brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: shimmerColor,
      highlightColor: shimmerHighlightColor,
      child: Column(
        children: List.generate(3, (index) => _buildPlaceholderCard()),
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Container(
          height: 20,
          width: 100,
          color: Colors.white,
        ),
        trailing: const Icon(Icons.expand_more),
      ),
    );
  }
}
