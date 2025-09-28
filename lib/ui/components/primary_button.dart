import 'package:flutter/material.dart';

import '../tokens.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppComponentSpecs.primaryButtonHeight,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: AppButtonStyles.primary,
        child: Text(label),
      ),
    );
  }
}
