// lib/widgets/nutrient_grid_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NutrientGridItem extends StatelessWidget {
  final String iconPath;
  final String name;
  final String value;

  const NutrientGridItem({
    super.key,
    required this.iconPath,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // The SvgPicture.asset widget is now correctly imported
            // and used to display the SVG icon.
            SvgPicture.asset(
              iconPath,
              height: 32,
              width: 32,
              colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                // The deprecated `withOpacity` has been replaced with `withAlpha`
                // to set the color's transparency.
                Text(value, style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color?.withAlpha((255 * 0.7).round()))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
