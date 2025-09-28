import 'package:flutter/material.dart';

import '../tokens.dart';

class HintButton extends StatelessWidget {
  const HintButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: AppButtonStyles.outline,
      child: Text(label),
    );
  }
}
