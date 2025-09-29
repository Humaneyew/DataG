import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.category,
  });

  final double value;
  final String? category;

  @override
  Widget build(BuildContext context) {
    final color = category != null
        ? AppColors.categoryColors[category!] ?? AppColors.primary
        : AppColors.primary;

    return ClipRRect(
      borderRadius: AppRadii.pill,
      child: LinearProgressIndicator(
        minHeight: 3,
        value: value,
        backgroundColor: Colors.white.withOpacity(0.12),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
