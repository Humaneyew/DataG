import 'package:flutter/material.dart';

import '../tokens.dart';
import 'card_tile.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.progress,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final double progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CardTile(
      leading: Icon(icon, color: AppColors.accentSecondary, size: 28),
      title: Text(title),
      subtitle: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: AppComponentSpecs.progressBarHeight,
          backgroundColor: AppColors.borderMuted,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.accentSecondary),
        ),
      ),
      height: 72,
      onTap: onTap,
    );
  }
}
