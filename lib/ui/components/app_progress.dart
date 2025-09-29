import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class AppProgress extends StatelessWidget {
  const AppProgress({
    super.key,
    required this.value,
    required this.color,
    this.height = 3,
  });

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.small),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height.clamp(2, 4).toDouble(),
        backgroundColor: Colors.white.withOpacity(0.12),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
