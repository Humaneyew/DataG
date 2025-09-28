import 'package:flutter/material.dart';

import '../tokens.dart';

class SecondaryTextButton extends StatelessWidget {
  const SecondaryTextButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentSecondary,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(label),
    );
  }
}
