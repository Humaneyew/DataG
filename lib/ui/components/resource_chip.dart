import 'package:flutter/material.dart';

import '../tokens.dart';

class ResourceChip extends StatelessWidget {
  const ResourceChip({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.accentSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.chip,
          ),
        ],
      ),
    );
  }
}
